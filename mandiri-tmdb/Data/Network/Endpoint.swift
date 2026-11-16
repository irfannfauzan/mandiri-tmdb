//
//  Endpoint.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

enum Endpoint {
    case genres
    case discover(genreId: Int, page: Int)
    case movieDetail(id: Int)
    case movieVideos(id: Int)
    case reviews(movieId: Int, page: Int)

    private static let baseURL = "https://api.themoviedb.org/3"

    private var path: String {
        switch self {
        case .genres: return "/genre/movie/list"
        case .discover: return "/discover/movie"
        case .movieDetail(let id): return "/movie/\(id)"
        case .movieVideos(let id): return "/movie/\(id)/videos"
        case .reviews(let movieId, _): return "/movie/\(movieId)/reviews"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case .genres, .movieDetail, .movieVideos:
            return [URLQueryItem(name: "language", value: "en")]
        case .discover(let genreId, let page):
            return [
                URLQueryItem(name: "with_genres", value: "\(genreId)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "language", value: "en")
            ]
        case .reviews(_, let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "en")
            ]
        }
    }

    var url: URL? {
        var components = URLComponents(string: Self.baseURL + path)
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        return components?.url
    }
}
