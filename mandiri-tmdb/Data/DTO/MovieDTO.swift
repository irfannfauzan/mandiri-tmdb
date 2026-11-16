//
//  MovieDTO.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct MoviePageDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

extension MovieDTO {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title ?? "Untitled",
            overview: overview ?? "",
            posterURL: posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w342\($0)") },
            releaseYear: String((releaseDate ?? "").prefix(4)),
            rating: voteAverage ?? 0
        )
    }
}

extension MoviePageDTO {
    func toDomain() -> MoviePage {
        MoviePage(movies: results.map { $0.toDomain() }, page: page, totalPages: min(totalPages, 500))
    }
}
