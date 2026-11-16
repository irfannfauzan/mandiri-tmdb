//
//  MovieRepository.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchMovies(genreId: Int, page: Int) async throws -> MoviePage {
        let response: MoviePageDTO = try await apiClient.request(.discover(genreId: genreId, page: page))
        return response.toDomain()
    }
}
