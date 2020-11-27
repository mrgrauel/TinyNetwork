//
//  Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public protocol Endpoint {
    associatedtype Value
    
    var urlRequest: URLRequest { get }
    var parse: (Data) throws -> Value { get }
}
