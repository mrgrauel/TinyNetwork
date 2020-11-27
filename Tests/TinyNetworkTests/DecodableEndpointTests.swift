//
//  DecodableEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class DecodableEndpointTests: XCTestCase {
    typealias Endpoint = DecodableEndpoint<MockResource>
    
    var url: URL!
    var endpoint: Endpoint!
    
    override func setUpWithError() throws {
        url = try XCTUnwrap(URL(string: "https://www.github.com"))
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
        let resource = MockResource(name: "foobar")
        let data = try JSONEncoder().encode(resource)
        XCTAssertEqual(try endpoint.parse(data), resource)
    }
    
    // MARK: Mocks
    
    struct MockResource: Codable, Equatable {
        let name: String
    }
}


