//
//  ReviewPresenter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol ReviewsPresenterProtocol: AnyObject {
    var title: String { get }
    var numberOfReviews: Int { get }
    func review(at index: Int) -> Review
    func formattedDate(for review: Review) -> String
    func viewDidLoad()
    func didTapRetry()
    func willDisplayRow(at index: Int)
}

@MainActor
final class ReviewsPresenter: ReviewsPresenterProtocol {

    weak var view: ReviewsViewProtocol?
    private let interactor: ReviewsInteractorProtocol
    private let router: ReviewsRouterProtocol
    private let movieTitle: String

    private var reviews: [Review] = []
    private var nextPage = 1
    private var hasMore = true
    private var isLoading = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(movieTitle: String, interactor: ReviewsInteractorProtocol, router: ReviewsRouterProtocol) {
        self.movieTitle = movieTitle
        self.interactor = interactor
        self.router = router
    }

    var title: String { "Reviews" }
    var numberOfReviews: Int { reviews.count }

    func review(at index: Int) -> Review {
        reviews[index]
    }

    func formattedDate(for review: Review) -> String {
        guard let date = review.createdAt else { return "" }
        return Self.dateFormatter.string(from: date)
    }

    func viewDidLoad() {
        loadFirstPage()
    }

    func didTapRetry() {
        loadFirstPage()
    }

    func willDisplayRow(at index: Int) {
        guard index >= reviews.count - 3 else { return }
        loadNextPage()
    }

    private func loadFirstPage() {
        reviews = []
        nextPage = 1
        hasMore = true
        isLoading = true
        view?.showLoading()
        interactor.fetchReviews(page: 1)
    }

    private func loadNextPage() {
        guard !isLoading, hasMore, !reviews.isEmpty else { return }
        isLoading = true
        view?.showLoadingMore(true)
        interactor.fetchReviews(page: nextPage)
    }
}

extension ReviewsPresenter: ReviewsInteractorOutputProtocol {

    func didFetchReviews(_ page: ReviewPage) {
        isLoading = false
        view?.showLoadingMore(false)

        reviews.append(contentsOf: page.reviews)
        nextPage = page.page + 1
        hasMore = page.hasMore && !page.reviews.isEmpty

        if reviews.isEmpty {
            view?.showEmpty(message: "No reviews yet for \(movieTitle).")
        } else {
            view?.showReviews()
        }
    }

    func didFailFetchingReviews(_ message: String, page: Int) {
        isLoading = false
        view?.showLoadingMore(false)

        if page == 1 {
            view?.showError(message: message)
        } else {
            view?.showLoadMoreError(message: message)
        }
    }
}
