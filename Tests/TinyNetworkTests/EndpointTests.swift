//
//  DecodableEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class EndpointTests: XCTestCase {

    var url: URL!
    var endpoint: Endpoint<MockResource>!

    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.github.com"))
        endpoint = Endpoint<MockResource>(url: url, method: .get(nil))
    }

    func testURL() throws {
        XCTAssertEqual(endpoint.urlRequest.url, url)
    }

    // MARK: Mocks

    struct MockResource: Codable, Equatable {
        let name: String
    }
}
