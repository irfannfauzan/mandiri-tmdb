//
//  APIError.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transportError(URLError)
    case invalidResponse
    case httpStatus(Int, message: String?)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .transportError(let error):
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return "No internet connection."
            case .cannotFindHost, .dnsLookupFailed:
                return "Server not found."
            case .cannotConnectToHost:
                return "Can't connect to the server."
            case .timedOut:
                return "The request timed out. Please try again."
            case .badURL, .unsupportedURL:
                return "Invalid URL."
            case .cancelled:
                return "The request was cancelled."
            default:
                return "Network error. Please try again."
            }
        case .invalidResponse:
            return "Invalid response from server."
        case .httpStatus(let code, let message):
            return message ?? "Server error (\(code))."
        case .decoding:
            return "Couldn't read the data from server."
        }
    }
}
