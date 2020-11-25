//
//  ImageEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
import SwiftUI
@testable import TinyNetwork

class ImageEndpointTests: XCTestCase {

    func testURLRequest() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = ImageEndpoint(url: url)
        XCTAssertEqual(endpoint.urlRequest.url, url)
        XCTAssertEqual(endpoint.urlRequest.httpMethod, "GET")
    }
    
    func testParse() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = ImageEndpoint(url: url)
        let image = try XCTUnwrap(UIImage(systemName: "square.and.pencil"))
        
        XCTAssertNotNil(try endpoint.parse(image.pngData()!))
    }
    
    func testParseError() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = ImageEndpoint(url: url)
        XCTAssertThrowsError(try endpoint.parse(Data()))
    }
}
