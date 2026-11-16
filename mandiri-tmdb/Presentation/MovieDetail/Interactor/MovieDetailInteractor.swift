//
//  MovieDetailInteractor.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol MovieDetailInteractorProtocol: AnyObject {
    func fetchDetail()
    func cancel()
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func didFetchDetail(_ detail: MovieDetail, trailer: Trailer?)
    func didFailFetchingDetail(_ message: String)
}

@MainActor
final class MovieDetailInteractor: MovieDetailInteractorProtocol {

    weak var presenter: MovieDetailInteractorOutputProtocol?

    private let movieId: Int
    private let fetchDetailUseCase: FetchMovieDetailUseCaseProtocol
    private let fetchTrailerUseCase: FetchMovieTrailerUseCaseProtocol
    private var task: Task<Void, Never>?

    init(
        movieId: Int,
        fetchDetailUseCase: FetchMovieDetailUseCaseProtocol,
        fetchTrailerUseCase: FetchMovieTrailerUseCaseProtocol
    ) {
        self.movieId = movieId
        self.fetchDetailUseCase = fetchDetailUseCase
        self.fetchTrailerUseCase = fetchTrailerUseCase
    }

    func fetchDetail() {
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }

            async let detail = fetchDetailUseCase.execute(movieId: movieId)
            async let trailer = fetchTrailerUseCase.execute(movieId: movieId)

            do {
                let detailResult = try await detail
                let trailerResult = try? await trailer
                guard !Task.isCancelled else { return }
                presenter?.didFetchDetail(detailResult, trailer: trailerResult)
            } catch {
                guard !Task.isCancelled else { return }
                presenter?.didFailFetchingDetail(error.localizedDescription)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
