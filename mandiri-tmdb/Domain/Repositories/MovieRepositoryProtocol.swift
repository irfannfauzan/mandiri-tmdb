//
//  MovieRepositoryProtocol.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol MovieRepositoryProtocol {
    func fetchMovies(genreId: Int, page: Int) async throws -> MoviePage
}
