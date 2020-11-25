//
//  URLSession+Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation
import Combine

public extension URLSession {
    func dataTask<Resource>(with endpoint: Endpoint<Resource>, completionHandler: @escaping (Swift.Result<Resource, Swift.Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: endpoint.urlRequest) { data, _, error in
            do {
                if let error = error {
                    throw error
                }
                completionHandler(.success(try endpoint.parse(data!)))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}

@available(iOS 13, watchOS 6, OSX 10.15, *)
public extension URLSession {
    func dataTaskPublisher<Resource>(for endpoint: Endpoint<Resource>) -> AnyPublisher<Resource, Swift.Error> {
        dataTaskPublisher(for: endpoint.urlRequest)
            .tryMap { data, _ -> Resource in
                try endpoint.parse(data)
            }
            .eraseToAnyPublisher()
    }
}
