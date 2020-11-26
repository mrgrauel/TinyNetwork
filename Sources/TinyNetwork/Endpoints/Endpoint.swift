//
//  Endpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public protocol Endpoint {
    associatedtype Value
    
    var url: URL { get }
    var parse: (Data) throws -> Value { get }
    
    init(url: URL)
}
