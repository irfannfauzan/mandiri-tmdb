//
//  Review.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

struct Review: Equatable {
    let id: String
    let author: String
    let avatarURL: URL?
    let rating: Double?
    let content: String
    let createdAt: Date?
}

struct ReviewPage {
    let reviews: [Review]
    let page: Int
    let totalPages: Int

    var hasMore: Bool { page < totalPages }
}
