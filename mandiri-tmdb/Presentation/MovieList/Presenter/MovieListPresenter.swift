//
//  MovieListPresenter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    var title: String { get }
    var numberOfMovies: Int { get }
    func movie(at index: Int) -> Movie
    func viewDidLoad()
    func didTapRetry()
    func willDisplayItem(at index: Int)
    func didSelectMovie(at index: Int)
}

@MainActor
final class MovieListPresenter: MovieListPresenterProtocol {

    weak var view: MovieListViewProtocol?
    private let interactor: MovieListInteractorProtocol
    private let router: MovieListRouterProtocol
    private let genre: Genre

    private var movies: [Movie] = []
    private var nextPage = 1
    private var hasMore = true
    private var isLoading = false

    init(genre: Genre, interactor: MovieListInteractorProtocol, router: MovieListRouterProtocol) {
        self.genre = genre
        self.interactor = interactor
        self.router = router
    }

    var title: String { genre.name }
    var numberOfMovies: Int { movies.count }

    func movie(at index: Int) -> Movie {
        movies[index]
    }

    func viewDidLoad() {
        loadFirstPage()
    }

    func didTapRetry() {
        loadFirstPage()
    }

    func willDisplayItem(at index: Int) {
        guard index >= movies.count - 6 else { return }
        loadNextPage()
    }

    func didSelectMovie(at index: Int) {
        guard movies.indices.contains(index) else { return }
        router.navigateToDetail(movie: movies[index])
    }

    private func loadFirstPage() {
        movies = []
        nextPage = 1
        hasMore = true
        isLoading = true
        view?.showLoading()
        interactor.fetchMovies(page: 1)
    }

    private func loadNextPage() {
        guard !isLoading, hasMore, !movies.isEmpty else { return }
        isLoading = true
        view?.showLoadingMore(true)
        interactor.fetchMovies(page: nextPage)
    }
}

extension MovieListPresenter: MovieListInteractorOutputProtocol {

    func didFetchMovies(_ page: MoviePage) {
        isLoading = false
        view?.showLoadingMore(false)

        movies.append(contentsOf: page.movies)
        nextPage = page.page + 1
        hasMore = page.hasMore && !page.movies.isEmpty

        if movies.isEmpty {
            view?.showEmpty(message: "No movies found for this genre.")
        } else {
            view?.showMovies()
        }
    }

    func didFailFetchingMovies(_ message: String, page: Int) {
        isLoading = false
        view?.showLoadingMore(false)

        if page == 1 {
            view?.showError(message: message)
        } else {
            view?.showLoadMoreError(message: message)
        }
    }
}
