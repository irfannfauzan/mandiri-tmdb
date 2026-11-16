//
//  ReviewRepositoryProtocol.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol ReviewRepositoryProtocol {
    func fetchReviews(movieId: Int, page: Int) async throws -> ReviewPage
}
