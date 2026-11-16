//
//  MovieDetailDTO.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct MovieDetailDTO: Decodable {
    let id: Int
    let title: String?
    let tagline: String?
    let overview: String?
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let genres: [GenreDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, tagline, overview, runtime, genres
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieDetailDTO {
    func toDomain() -> MovieDetail {
        MovieDetail(
            id: id,
            title: title ?? "Untitled",
            tagline: tagline ?? "",
            overview: overview ?? "",
            backdropURL: backdropPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w780\($0)") },
            posterURL: posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w342\($0)") },
            releaseYear: String((releaseDate ?? "").prefix(4)),
            runtime: runtime ?? 0,
            rating: voteAverage ?? 0,
            voteCount: voteCount ?? 0,
            genres: genres?.map(\.name) ?? []
        )
    }
}

struct VideoResponseDTO: Decodable {
    let results: [VideoDTO]
}

struct VideoDTO: Decodable {
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool?
}
