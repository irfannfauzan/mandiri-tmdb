//
//  GenreBuilder.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

enum GenreModuleBuilder {

    static func build() -> UIViewController {
        let apiClient = APIClient()
        let repository = GenreRepository(apiClient: apiClient)
        let useCase = FetchGenresUseCase(repository: repository)
        
        let router = GenreListRouter()
        let interactor = GenreListInteractor(fetchGenresUseCase: useCase)
        let presenter = GenreListPresenter(interactor: interactor, router: router)
        let view = GenreListViewController(presenter: presenter)

        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
