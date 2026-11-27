//
//  TMDBAPI.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation
import Moya
import Alamofire

nonisolated enum TMDBAPI {
    case genres
    case discover(genreId: Int, page: Int)
    case movieDetail(id: Int)
    case movieVideos(id: Int)
    case reviews(movieId: Int, page: Int)
}

nonisolated extension TMDBAPI: TargetType {

    var baseURL: URL {
        URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .genres: return "/genre/movie/list"
        case .discover: return "/discover/movie"
        case .movieDetail(let id): return "/movie/\(id)"
        case .movieVideos(let id): return "/movie/\(id)/videos"
        case .reviews(let movieId, _): return "/movie/\(movieId)/reviews"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        [
            "Authorization": "Bearer \(SecretKey.tmdbToken)",
            "accept": "application/json"
        ]
    }

    private var parameters: [String: Any] {
        switch self {
        case .genres, .movieDetail, .movieVideos:
            return ["language": "en"]
        case .discover(let genreId, let page):
            return [
                "with_genres": genreId,
                "page": page,
                "sort_by": "popularity.desc",
                "language": "en"
            ]
        case .reviews(_, let page):
            return [
                "page": page,
                "language": "en"
            ]
        }
    }
}
