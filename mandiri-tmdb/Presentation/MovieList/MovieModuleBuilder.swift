//
//  MovieModuleBuilder.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

enum MovieListModuleBuilder {

    static func build(genre: Genre) -> UIViewController {
        let apiClient = MoyaAPIClient()
        let repository = MovieRepository(apiClient: apiClient)
        let useCase = FetchMoviesByGenreUseCase(repository: repository)

        let router = MovieListRouter()
        let interactor = MovieListInteractor(genreId: genre.id, fetchMoviesUseCase: useCase)
        let presenter = MovieListPresenter(genre: genre, interactor: interactor, router: router)
        let view = MovieListViewController(presenter: presenter)

        presenter.view = view
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
