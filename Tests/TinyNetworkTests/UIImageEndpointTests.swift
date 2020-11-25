//
//  UIImageEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class UIImageEndpointTests: XCTestCase {

    func testURLRequest() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = UIImageEndpoint(url: url)
        XCTAssertEqual(endpoint.urlRequest.url, url)
        XCTAssertEqual(endpoint.urlRequest.httpMethod, "GET")
    }
    
    func testParse() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = UIImageEndpoint(url: url)
        let image = try XCTUnwrap(UIImage(systemName: "square.and.pencil"))
        
        XCTAssertNotNil(try endpoint.parse(image.pngData()!))
    }
    
    func testParseError() throws {
        let url = URL(string: "https://www.github.com/image.png")!
        let endpoint = UIImageEndpoint(url: url)
        XCTAssertThrowsError(try endpoint.parse(Data()))
    }
}
