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

    public init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
    
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
}
