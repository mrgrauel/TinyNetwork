//
//  DecodableEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class DecodableEndpointTests: XCTestCase {

    func testInvalidPath() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        XCTAssertThrowsError(try DecodableEndpoint<MockResource>(domain: mockDomain, path: "path"))
    }

    func testURL() throws {
        let url = URL(string: "https://www.github.com")!
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        XCTAssertEqual(endpoint.urlRequest.url, url)
        XCTAssertEqual(endpoint.urlRequest.httpMethod, "GET")
    }

    func testDomainPath() throws {
        var mockDomain = MockDomain(host: "google.com", scheme: "https")
        var endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path")
        XCTAssertNotNil(endpoint)
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path")
        XCTAssertEqual(endpoint.urlRequest.httpMethod, "GET")

        mockDomain = MockDomain(host: "github.com", scheme: "https")
        endpoint = try .init(domain: mockDomain, path: "/")
        XCTAssertNotNil(endpoint)
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://github.com/")
    }

    func testQueryItemsEmpty() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        let endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path", queryItems: [])
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path?")
    }

    func testQueryItemsNoValue() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        let endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path", queryItems: [.init(name: "name", value: nil)])
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path?name")
    }

    func testQueryItemsSingle() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        let endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path", queryItems: [.init(name: "name", value: "value")])
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path?name=value")
    }

    func testQueryItems() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        var endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path", queryItems: [.init(name: "foo", value: "bar"), .init(name: "name", value: "value")])
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path?foo=bar&name=value")

        endpoint = try .init(domain: mockDomain, path: "/path", queryItems: [.init(name: "name", value: "value"), .init(name: "foo", value: "bar")])
        XCTAssertEqual(endpoint.urlRequest.url?.absoluteString, "https://google.com/path?name=value&foo=bar")
    }

    func testParse() throws {
        let mockDomain = MockDomain(host: "google.com", scheme: "https")
        let endpoint: DecodableEndpoint<MockResource> = try .init(domain: mockDomain, path: "/path")

        let resource = MockResource(name: "foobar")
        let data = try JSONEncoder().encode(resource)
        XCTAssertEqual(try endpoint.parse(data), resource)
    }
}

private struct MockDomain: Domain {
    var host: String
    var scheme: String
}

private struct MockResource: Codable, Equatable {
    let name: String
}
