//
//  FetchMovieDetailUseCase.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol FetchMovieDetailUseCaseProtocol {
    func execute(movieId: Int) async throws -> MovieDetail
}

final class FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    private let repository: MovieDetailRepositoryProtocol

    init(repository: MovieDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int) async throws -> MovieDetail {
        try await repository.fetchDetail(movieId: movieId)
    }
}
