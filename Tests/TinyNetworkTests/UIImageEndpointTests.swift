//
//  UIImageEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class UIImageEndpointTests: XCTestCase {

    var url: URL!
    var endpoint: UIImageEndpoint!
    
    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.github.com/image.png"))
        endpoint = UIImageEndpoint(url: url)
    }

    func testURL() throws {
        XCTAssertEqual(endpoint.url, url)
    }
    
    func testParse() throws {
        let image = try XCTUnwrap(UIImage(systemName: "square.and.pencil"))
        XCTAssertNotNil(try endpoint.parse(try XCTUnwrap(image.pngData())))
    }
    
    func testParseError() throws {
        XCTAssertThrowsError(try endpoint.parse(Data()))
    }
}
