//
//  GenreListRouter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol GenreListRouterProtocol: AnyObject {
    func navigateToMovieList(genre: Genre)
}

final class GenreListRouter: GenreListRouterProtocol {

    weak var viewController: UIViewController?

    func navigateToMovieList(genre: Genre) {
        let movieList = MovieListModuleBuilder.build(genre: genre)
        viewController?.navigationController?.pushViewController(movieList, animated: true)
    }
}
