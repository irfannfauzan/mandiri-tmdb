//
//  ReviewModuleBuilder.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

enum ReviewsModuleBuilder {

    static func build(movieId: Int, movieTitle: String) -> UIViewController {
        let apiClient = MoyaAPIClient()
        let repository = ReviewRepository(apiClient: apiClient)
        let useCase = FetchReviewsUseCase(repository: repository)

        let router = ReviewsRouter()
        let interactor = ReviewsInteractor(movieId: movieId, fetchReviewsUseCase: useCase)
        let presenter = ReviewsPresenter(movieTitle: movieTitle, interactor: interactor, router: router)
        let view = ReviewsViewController(presenter: presenter)

        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
