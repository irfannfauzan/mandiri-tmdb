//
//  APIClient.swift
//  mandiri-tmdb
//
//  Created by Vokal-Ican on 16/11/26.
//

import Foundation
import Moya
import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable>(_ target: TMDBAPI) async throws -> T
}

final class MoyaAPIClient: APIClientProtocol {

    private let provider: MoyaProvider<TMDBAPI>
    private let decoder: JSONDecoder

    init(provider: MoyaProvider<TMDBAPI> = MoyaProvider<TMDBAPI>(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }

    func request<T: Decodable>(_ target: TMDBAPI) async throws -> T {
        let (data, statusCode): (Data, Int) = try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: (response.data, response.statusCode))
                case .failure(let error):
                    continuation.resume(throwing: Self.mapError(error))
                }
            }
        }

        guard (200...299).contains(statusCode) else {
            let message = (try? decoder.decode(TMDBErrorDTO.self, from: data))?.statusMessage
            throw APIError.httpStatus(statusCode, message: message)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    private nonisolated static func mapError(_ error: MoyaError) -> Error {
        if case .underlying(let underlying, _) = error,
           let urlError = (underlying.asAFError?.underlyingError ?? underlying) as? URLError {
            return APIError.transportError(urlError)
        }
        return APIError.invalidResponse
    }
}
