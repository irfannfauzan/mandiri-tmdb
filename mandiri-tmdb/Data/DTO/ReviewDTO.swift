//
//  ReviewDTO.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct ReviewPageDTO: Decodable {
    let page: Int
    let results: [ReviewDTO]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct ReviewDTO: Decodable {
    let id: String
    let author: String?
    let content: String?
    let createdAt: String?
    let authorDetails: AuthorDetailsDTO?

    enum CodingKeys: String, CodingKey {
        case id, author, content
        case createdAt = "created_at"
        case authorDetails = "author_details"
    }
}

struct AuthorDetailsDTO: Decodable {
    let avatarPath: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case rating
        case avatarPath = "avatar_path"
    }
}

extension ReviewDTO {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    func toDomain() -> Review {
        Review(
            id: id,
            author: author ?? "Anonymous",
            avatarURL: Self.avatarURL(from: authorDetails?.avatarPath),
            rating: authorDetails?.rating,
            content: content ?? "",
            createdAt: createdAt.flatMap { Self.dateFormatter.date(from: $0) }
        )
    }

    private static func avatarURL(from path: String?) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        if path.hasPrefix("/http") {
            return URL(string: String(path.dropFirst()))
        }
        return URL(string: "https://image.tmdb.org/t/p/w92\(path)")
    }
}

extension ReviewPageDTO {
    func toDomain() -> ReviewPage {
        ReviewPage(reviews: results.map { $0.toDomain() }, page: page, totalPages: totalPages)
    }
}
