//
//  ReviewsInteractor.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol ReviewsInteractorProtocol: AnyObject {
    func fetchReviews(page: Int)
    func cancel()
}

protocol ReviewsInteractorOutputProtocol: AnyObject {
    func didFetchReviews(_ page: ReviewPage)
    func didFailFetchingReviews(_ message: String, page: Int)
}

@MainActor
final class ReviewsInteractor: ReviewsInteractorProtocol {

    weak var presenter: ReviewsInteractorOutputProtocol?

    private let movieId: Int
    private let fetchReviewsUseCase: FetchReviewsUseCaseProtocol
    private var task: Task<Void, Never>?

    init(movieId: Int, fetchReviewsUseCase: FetchReviewsUseCaseProtocol) {
        self.movieId = movieId
        self.fetchReviewsUseCase = fetchReviewsUseCase
    }

    func fetchReviews(page: Int) {
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await fetchReviewsUseCase.execute(movieId: movieId, page: page)
                guard !Task.isCancelled else { return }
                presenter?.didFetchReviews(result)
            } catch {
                guard !Task.isCancelled else { return }
                presenter?.didFailFetchingReviews(error.localizedDescription, page: page)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
