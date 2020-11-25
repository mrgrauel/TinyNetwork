//
//  DecodableEndpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public struct DecodableEndpoint<Resource>: Endpoint where Resource: Decodable {
    public typealias Value = Resource

    public let urlRequest: URLRequest

    public var parse: (Data) throws -> Value = { data in
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
        urlRequest = URLRequest(url: url)
    }

    public init(url: URL) {
        urlRequest = URLRequest(url: url)
    }
}
