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
    typealias Endpoint = ImageEndpoint
    
    var url: URL!
    var endpoint: Endpoint!
    
    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.github.com/image.png"))
        endpoint = Endpoint(url: url)
    }

    func testURL() throws {
        XCTAssertEqual(endpoint.urlRequest.url, url)
    }
    
    func testURLRequest() throws {
        let urlRequest = URLRequest(url: url)
        let endpoint = Endpoint(urlRequest: urlRequest)
        XCTAssertEqual(endpoint.urlRequest, urlRequest)
    }
    
    func testParse() throws {
        let image = try XCTUnwrap(UIImage(systemName: "square.and.pencil"))
        XCTAssertNotNil(try endpoint.parse(try XCTUnwrap(image.pngData())))
    }
    
    func testParseError() throws {
        XCTAssertThrowsError(try endpoint.parse(Data()))
    }
}
