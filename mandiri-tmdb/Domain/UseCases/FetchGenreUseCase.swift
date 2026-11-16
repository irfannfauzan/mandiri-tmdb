//
//  FetchGenresUseCase.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol FetchGenresUseCaseProtocol {
    func execute() async throws -> [Genre]
}

final class FetchGenresUseCase: FetchGenresUseCaseProtocol {
    private let repository: GenreRepositoryProtocol

    init(repository: GenreRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Genre] {
        try await repository.fetchGenres()
    }
}
