//
//  MovieListInteractor.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchMovies(page: Int)
    func cancel()
}

protocol MovieListInteractorOutputProtocol: AnyObject {
    func didFetchMovies(_ page: MoviePage)
    func didFailFetchingMovies(_ message: String, page: Int)
}

@MainActor
final class MovieListInteractor: MovieListInteractorProtocol {

    weak var presenter: MovieListInteractorOutputProtocol?

    private let genreId: Int
    private let fetchMoviesUseCase: FetchMoviesByGenreUseCaseProtocol
    private var task: Task<Void, Never>?

    init(genreId: Int, fetchMoviesUseCase: FetchMoviesByGenreUseCaseProtocol) {
        self.genreId = genreId
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }

    func fetchMovies(page: Int) {
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await fetchMoviesUseCase.execute(genreId: genreId, page: page)
                guard !Task.isCancelled else { return }
                presenter?.didFetchMovies(result)
            } catch {
                guard !Task.isCancelled else { return }
                presenter?.didFailFetchingMovies(error.localizedDescription, page: page)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
