//
//  DecodableEndpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public struct DecodableEndpoint<Resource>: Endpoint where Resource: Decodable {
    public typealias Value = Resource

    public let url: URL

    public var parse: (Data) throws -> Value = { data in
        try JSONDecoder().decode(Resource.self, from: data)
    }

    public init(url: URL) {
        self.url = url
    }
}
