//
//  TMDBErrorDTO.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

struct TMDBErrorDTO: Decodable {
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
    }
}
