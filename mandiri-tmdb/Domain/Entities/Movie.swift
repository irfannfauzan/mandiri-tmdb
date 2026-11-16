//
//  Movie.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct Movie: Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let releaseYear: String
    let rating: Double
}

struct MoviePage {
    let movies: [Movie]
    let page: Int
    let totalPages: Int

    var hasMore: Bool { page < totalPages }
}
