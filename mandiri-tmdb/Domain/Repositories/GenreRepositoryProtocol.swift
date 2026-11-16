//
//  GenreRepositoryProtocol.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

protocol GenreRepositoryProtocol {
    func fetchGenres() async throws -> [Genre]
}
