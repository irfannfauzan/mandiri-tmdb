//
//  ReviewRepository.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

final class ReviewRepository: ReviewRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchReviews(movieId: Int, page: Int) async throws -> ReviewPage {
        let response: ReviewPageDTO = try await apiClient.request(.reviews(movieId: movieId, page: page))
        return response.toDomain()
    }
}
