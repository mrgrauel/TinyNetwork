//
//  DecodableEndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class RequestTests: XCTestCase {

    func testHttpHeaderFields() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        var request = Request<MockResource>(url: url, method: .get(nil))
        request.headerFields = [
            "foobar": "1",
            "barfoo": "2"
        ]
        XCTAssertEqual(request.urlRequest.allHTTPHeaderFields, request.headerFields)
    }

    func testCachePolicy() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        var request = Request<MockResource>(url: url, method: .get(nil))
        request.cachePolicy = .reloadIgnoringLocalCacheData
        XCTAssertEqual(request.urlRequest.cachePolicy, .reloadIgnoringLocalCacheData)
    }

    func testGetRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        var request = Request<MockResource>(url: url, method: .get(nil))
        XCTAssertEqual(request.urlRequest.httpMethod, "GET")
        XCTAssertEqual(request.urlRequest.url, url)
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)

        request = Request<MockResource>(url: url, method: .get([
            .init(name: "foobar", value: "1"),
            .init(name: "barfoo", value: "2")
        ]))
        XCTAssertEqual(request.urlRequest.httpMethod, "GET")
        XCTAssertEqual(request.urlRequest.url?.absoluteString, "https://www.github.com?barfoo=2&foobar=1")
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)
    }

    func testPostRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        var request = Request<MockResource>(url: url, method: .post(nil))
        XCTAssertEqual(request.urlRequest.httpMethod, "POST")
        XCTAssertEqual(request.urlRequest.url, url)
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)

        let data = "foobar".data(using: .utf8)
        request = Request<MockResource>(url: url, method: .post(data))
        XCTAssertEqual(request.urlRequest.httpMethod, "POST")
        XCTAssertEqual(request.urlRequest.url?.absoluteString, "https://www.github.com")
        XCTAssertEqual(request.urlRequest.httpBody, data)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)
    }

    func testPutRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        var request = Request<MockResource>(url: url, method: .put(nil))
        XCTAssertEqual(request.urlRequest.httpMethod, "PUT")
        XCTAssertEqual(request.urlRequest.url, url)
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)

        let data = "foobar".data(using: .utf8)
        request = Request<MockResource>(url: url, method: .put(data))
        XCTAssertEqual(request.urlRequest.httpMethod, "PUT")
        XCTAssertEqual(request.urlRequest.url?.absoluteString, "https://www.github.com")
        XCTAssertEqual(request.urlRequest.httpBody, data)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)
    }

    func testDeleteRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        let request = Request<MockResource>(url: url, method: .delete)
        XCTAssertEqual(request.urlRequest.httpMethod, "DELETE")
        XCTAssertEqual(request.urlRequest.url, url)
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)
    }

    func testHeadRequest() throws {
        let url = try XCTUnwrap(URL(string: "https://www.github.com"))
        let request = Request<MockResource>(url: url, method: .head)
        XCTAssertEqual(request.urlRequest.httpMethod, "HEAD")
        XCTAssertEqual(request.urlRequest.url, url)
        XCTAssertNil(request.urlRequest.httpBody)
        XCTAssertEqual(request.urlRequest.cachePolicy, .useProtocolCachePolicy)
    }

    // MARK: Mocks

    struct MockResource: Codable, Equatable {
        let name: String
    }
}
