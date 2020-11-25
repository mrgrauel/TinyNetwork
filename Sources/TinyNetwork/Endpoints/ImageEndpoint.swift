//
//  ImageEndpoint.swift
//  TinyNetwork
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, watchOS 6.0, *)
public struct ImageEndpoint: Endpoint {
    public typealias Value = Image
    public let urlRequest: URLRequest
    
    public let parse: (Data) throws -> Value = { data in
        guard let image = UIImage(data: data) else {
            throw Error.invalidImageData
        }
        return Image(uiImage: image)
    }
    
    public init(url: URL) {
        self.urlRequest = URLRequest(url: url)
    }
}
