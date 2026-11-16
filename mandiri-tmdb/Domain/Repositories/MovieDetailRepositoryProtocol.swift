//
//  MovieDetailRepositoryProtocol.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol MovieDetailRepositoryProtocol {
    func fetchDetail(movieId: Int) async throws -> MovieDetail
    func fetchTrailer(movieId: Int) async throws -> Trailer?
}
