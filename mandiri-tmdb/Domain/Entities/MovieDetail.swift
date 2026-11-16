//
//  MovieDetail.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct MovieDetail: Equatable {
    let id: Int
    let title: String
    let tagline: String
    let overview: String
    let backdropURL: URL?
    let posterURL: URL?
    let releaseYear: String
    let runtime: Int
    let rating: Double
    let voteCount: Int
    let genres: [String]
}

struct Trailer: Equatable {
    let key: String
    let name: String

    var watchURL: URL? { URL(string: "https://www.youtube.com/watch?v=\(key)") }
}
