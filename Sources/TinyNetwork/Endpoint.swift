//
//  Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public struct Endpoint<Resource> where Resource: Decodable {
    private let url: URL

    public var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = httpHeaderFields
        urlRequest.httpMethod = httpMethod.method

        switch httpMethod {
        case .get:
            break
        case let .post(body):
            urlRequest.httpBody = body
        }

        return urlRequest
    }

    public var httpMethod: HTTPMethod = .get
    public var httpHeaderFields: [String: String]?

    public var parse: (Data) throws -> Resource = { data in
        try JSONDecoder().decode(Resource.self, from: data)
    }

    public init(domain: Domain,
                path: String,
                queryItems: [URLQueryItem]? = nil) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = domain.scheme
        urlComponents.host = domain.host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw Error.invalidURL
        }
        self.url = url
    }

    public init(url: URL) {
        self.url = url
    }
}
