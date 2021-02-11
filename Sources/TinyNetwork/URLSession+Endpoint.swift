//
//  URLSession+Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation
import Combine

public extension URLSession {
    enum Error: Swift.Error {
        case networking(URLError)
        case decoding(Swift.Error)
    }

    @available(iOS 13, watchOS 6, OSX 10.15, *)
    func publisher(for endpoint: Endpoint<Data>) -> AnyPublisher<Data, Swift.Error> {
        dataTaskPublisher(for: endpoint.urlRequest)
            .mapError(Error.networking)
            .map(\.data)
            .eraseToAnyPublisher()
    }

    @available(iOS 13, watchOS 6, OSX 10.15, *)
    func publisher<Response: Decodable>(
        for endpoint: Endpoint<Response>,
        using decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Response, Swift.Error> {
        dataTaskPublisher(for: endpoint.urlRequest)
            .mapError(Error.networking)
            .map(\.data)
            .decode(type: Response.self, decoder: decoder)
            .mapError(Error.decoding)
            .eraseToAnyPublisher()
    }
}

public extension URLSession {
    func dataTask(
        for endpoint: Endpoint<Data>,
        completionHandler: @escaping (Swift.Result<Data, Swift.Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: endpoint.urlRequest) { data, _, error in
            do {
                if let error = error {
                    throw error
                }
                completionHandler(.success(data!))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    func dataTask<Response: Decodable>(
        for endpoint: Endpoint<Response>,
        using decoder: JSONDecoder = .init(),
        completionHandler: @escaping (Swift.Result<Response, Swift.Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: endpoint.urlRequest) { data, _, error in
            do {
                if let error = error {
                    throw error
                }
                let response = try decoder.decode(Response.self, from: data!)
                completionHandler(.success(response))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
