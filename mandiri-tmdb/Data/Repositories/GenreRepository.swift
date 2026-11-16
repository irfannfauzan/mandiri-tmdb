//
//  GenreRepository.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

final class GenreRepository: GenreRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchGenres() async throws -> [Genre] {
        let response: GenreResponseDTO = try await apiClient.request(.genres)
        return response.genres.map { $0.toDomain() }
    }
}
