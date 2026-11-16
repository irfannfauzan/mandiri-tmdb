//
//  FetchMovieTrailerUseCase.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol FetchMovieTrailerUseCaseProtocol {
    func execute(movieId: Int) async throws -> Trailer?
}

final class FetchMovieTrailerUseCase: FetchMovieTrailerUseCaseProtocol {
    private let repository: MovieDetailRepositoryProtocol

    init(repository: MovieDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int) async throws -> Trailer? {
        try await repository.fetchTrailer(movieId: movieId)
    }
}
