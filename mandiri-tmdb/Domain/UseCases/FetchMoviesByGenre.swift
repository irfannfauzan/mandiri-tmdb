//
//  FetchMoviesByGenreUseCase.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol FetchMoviesByGenreUseCaseProtocol {
    func execute(genreId: Int, page: Int) async throws -> MoviePage
}

final class FetchMoviesByGenreUseCase: FetchMoviesByGenreUseCaseProtocol {
    private let repository: MovieRepositoryProtocol

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute(genreId: Int, page: Int) async throws -> MoviePage {
        try await repository.fetchMovies(genreId: genreId, page: page)
    }
}
