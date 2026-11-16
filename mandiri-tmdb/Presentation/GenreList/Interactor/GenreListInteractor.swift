//
//  GenreListInteractor.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

protocol GenreListInteractorProtocol: AnyObject {
    func fetchGenres()
    func cancel()
}

protocol GenreListInteractorOutputProtocol: AnyObject {
    func didFetchGenres(_ genres: [Genre])
    func didFailFetchingGenres(_ message: String)
}

@MainActor
final class GenreListInteractor: GenreListInteractorProtocol {

    weak var presenter: GenreListInteractorOutputProtocol?

    private let fetchGenresUseCase: FetchGenresUseCaseProtocol
    private var task: Task<Void, Never>?

    init(fetchGenresUseCase: FetchGenresUseCaseProtocol) {
        self.fetchGenresUseCase = fetchGenresUseCase
    }

    func fetchGenres() {
        task?.cancel()

        task = Task { [weak self] in
            guard let self else { return }
            do {
                let genres = try await fetchGenresUseCase.execute()
                guard !Task.isCancelled else { return }
                presenter?.didFetchGenres(genres)
            } catch {
                guard !Task.isCancelled else { return }
                presenter?.didFailFetchingGenres(error.localizedDescription)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
