//
//  MovieListRouter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol MovieListRouterProtocol: AnyObject {
    func navigateToDetail(movie: Movie)
}

final class MovieListRouter: MovieListRouterProtocol {

    weak var viewController: UIViewController?

    func navigateToDetail(movie: Movie) {
        let detail = MovieDetailModuleBuilder.build(movieId: movie.id)
        viewController?.navigationController?.pushViewController(detail, animated: true)
    }
}
