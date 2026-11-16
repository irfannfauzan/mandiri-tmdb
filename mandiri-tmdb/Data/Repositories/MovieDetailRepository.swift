//
//  MovieDetailRepository.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

final class MovieDetailRepository: MovieDetailRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchDetail(movieId: Int) async throws -> MovieDetail {
        let response: MovieDetailDTO = try await apiClient.request(.movieDetail(id: movieId))
        return response.toDomain()
    }

    func fetchTrailer(movieId: Int) async throws -> Trailer? {
        let response: VideoResponseDTO = try await apiClient.request(.movieVideos(id: movieId))
        let trailers = response.results.filter { $0.site == "YouTube" && $0.type == "Trailer" }
        let picked = trailers.first { $0.official == true } ?? trailers.first
        return picked.map { Trailer(key: $0.key, name: $0.name) }
    }
}
