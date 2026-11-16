//
//  GenreListPresenter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol GenreListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapRetry()
    func didSelectGenre(at index: Int)
}

@MainActor
final class GenreListPresenter: GenreListPresenterProtocol {

    weak var view: GenreListViewProtocol?
    private let interactor: GenreListInteractorProtocol
    private let router: GenreListRouterProtocol

    private var genres: [Genre] = []

    init(interactor: GenreListInteractorProtocol, router: GenreListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        loadGenres()
    }

    func didTapRetry() {
        loadGenres()
    }

    func didSelectGenre(at index: Int) {
        guard genres.indices.contains(index) else { return }
        router.navigateToMovieList(genre: genres[index])
    }

    private func loadGenres() {
        view?.showLoading()
        interactor.fetchGenres()
    }
}

// MARK: - GenreListInteractorOutputProtocol

extension GenreListPresenter: GenreListInteractorOutputProtocol {

    func didFetchGenres(_ genres: [Genre]) {
        self.genres = genres
        if genres.isEmpty {
            view?.showEmpty(message: "No genres found.")
        } else {
            view?.showGenres(genres)
        }
    }

    func didFailFetchingGenres(_ message: String) {
        view?.showError(message: message)
    }
}
