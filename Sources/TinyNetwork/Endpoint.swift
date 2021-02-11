//
//  Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public struct Endpoint<Response> {
    let url: URL
    let method: HttpMethod
    
    var headers: [String: String]?

    public init(url: URL, method: HttpMethod) {
        self.url = url
        self.method = method
    }
}

public extension Endpoint {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)

        switch method {
        case .post(let data), .put(let data):
            request.httpBody = data
        case .get(let queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create a url from components...")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.allHTTPHeaderFields = headers
        request.httpMethod = method.name
        return request
    }
}
