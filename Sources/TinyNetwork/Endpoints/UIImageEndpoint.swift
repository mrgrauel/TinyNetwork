//
//  UIImageEndpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation
import UIKit

public struct UIImageEndpoint: Endpoint {
    public typealias Value = UIImage
    public let urlRequest: URLRequest
    
    public let parse: (Data) throws -> Value = { data in
        guard let image = UIImage(data: data) else {
            throw Error.invalidImageData
        }
        return image
    }
    
    public init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
}
