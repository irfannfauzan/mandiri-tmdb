//
//  ReviewRouter.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import UIKit

protocol ReviewsRouterProtocol: AnyObject {}

final class ReviewsRouter: ReviewsRouterProtocol {
    weak var viewController: UIViewController?
}
