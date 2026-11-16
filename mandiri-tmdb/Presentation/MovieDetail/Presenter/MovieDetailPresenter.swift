//
//  MovieDetailPresenter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapRetry()
    func didTapTrailer()
    func didTapReviews()
}

@MainActor
final class MovieDetailPresenter: MovieDetailPresenterProtocol {

    weak var view: MovieDetailViewProtocol?
    private let interactor: MovieDetailInteractorProtocol
    private let router: MovieDetailRouterProtocol

    private var detail: MovieDetail?
    private var trailer: Trailer?

    init(interactor: MovieDetailInteractorProtocol, router: MovieDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        load()
    }

    func didTapRetry() {
        load()
    }

    func didTapTrailer() {
        guard let trailer else { return }
        router.openTrailer(trailer)
    }

    func didTapReviews() {
        guard let detail else { return }
        router.navigateToReviews(movieId: detail.id, title: detail.title)
    }

    private func load() {
        view?.showLoading()
        interactor.fetchDetail()
    }

    private func formatRuntime(_ minutes: Int) -> String {
        guard minutes > 0 else { return "" }
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours)h \(mins)m" : "\(mins)m"
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutputProtocol {

    func didFetchDetail(_ detail: MovieDetail, trailer: Trailer?) {
        self.detail = detail
        self.trailer = trailer

        let meta = [
            detail.releaseYear,
            formatRuntime(detail.runtime),
            "★ \(String(format: "%.1f", detail.rating)) (\(detail.voteCount))"
        ]
        .filter { !$0.isEmpty }
        .joined(separator: " · ")

        view?.showDetail(
            detail,
            meta: meta,
            genres: detail.genres.joined(separator: ", "),
            hasTrailer: trailer != nil
        )
    }

    func didFailFetchingDetail(_ message: String) {
        view?.showError(message: message)
    }
}
