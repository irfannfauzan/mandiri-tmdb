//
//  GenreDTO.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

extension GenreDTO {
    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}
