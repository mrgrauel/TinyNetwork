//
//  HTTPMethod.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation

public enum HTTPMethod {
    case get
    case post(Data)
}

extension HTTPMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
