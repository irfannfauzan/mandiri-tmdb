//
//  FetchReviewsUseCase.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol FetchReviewsUseCaseProtocol {
    func execute(movieId: Int, page: Int) async throws -> ReviewPage
}

final class FetchReviewsUseCase: FetchReviewsUseCaseProtocol {
    private let repository: ReviewRepositoryProtocol

    init(repository: ReviewRepositoryProtocol) {
        self.repository = repository
    }

    func execute(movieId: Int, page: Int) async throws -> ReviewPage {
        try await repository.fetchReviews(movieId: movieId, page: page)
    }
}
