//
//  URLSession+Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation
import Combine

public extension URLSession {
    func dataTask<E: Endpoint>(with endpoint: E, completionHandler: @escaping (Swift.Result<E.Value, Swift.Error>) -> Void) -> URLSessionDataTask {
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
    func dataTaskPublisher<E: Endpoint>(for endpoint: E) -> AnyPublisher<E.Value, Swift.Error> {
        dataTaskPublisher(for: endpoint.urlRequest)
            .tryMap { data, _ -> E.Value in
                try endpoint.parse(data)
            }
            .eraseToAnyPublisher()
    }
}
