//
//  MovieDetailRouter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol MovieDetailRouterProtocol: AnyObject {
    func openTrailer(_ trailer: Trailer)
    func navigateToReviews(movieId: Int, title: String)
}

final class MovieDetailRouter: MovieDetailRouterProtocol {

    weak var viewController: UIViewController?

    func openTrailer(_ trailer: Trailer) {
        let trailerVC = TrailerViewController(trailer: trailer)
        let nav = UINavigationController(rootViewController: trailerVC)
        viewController?.present(nav, animated: true)
    }

    func navigateToReviews(movieId: Int, title: String) {
        let reviews = ReviewsModuleBuilder.build(movieId: movieId, movieTitle: title)
        viewController?.navigationController?.pushViewController(reviews, animated: true)
    }
}
