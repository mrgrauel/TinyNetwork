//
//  DecodableEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class DecodableEndpointTests: XCTestCase {
    private var url: URL!
    private var endpoint: DecodableEndpoint<MockResource>!
    
    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.github.com"))
        endpoint = DecodableEndpoint<MockResource>(url: url)
    }

    func testURL() throws {
        XCTAssertEqual(endpoint.url, url)
    }

    func testParse() throws {
        let resource = MockResource(name: "foobar")
        let data = try JSONEncoder().encode(resource)
        XCTAssertEqual(try endpoint.parse(data), resource)
    }
}

private struct MockResource: Codable, Equatable {
    let name: String
}
