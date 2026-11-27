//
//  MovieDetailModuleBuilder.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

enum MovieDetailModuleBuilder {

    static func build(movieId: Int) -> UIViewController {
        let apiClient = MoyaAPIClient()
        let repository = MovieDetailRepository(apiClient: apiClient)
        let detailUseCase = FetchMovieDetailUseCase(repository: repository)
        let trailerUseCase = FetchMovieTrailerUseCase(repository: repository)

        let router = MovieDetailRouter()
        let interactor = MovieDetailInteractor(
            movieId: movieId,
            fetchDetailUseCase: detailUseCase,
            fetchTrailerUseCase: trailerUseCase
        )
        let presenter = MovieDetailPresenter(interactor: interactor, router: router)
        let view = MovieDetailViewController(presenter: presenter)

        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
