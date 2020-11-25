//
//  HTTPMethodTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
@testable import TinyNetwork

class HTTPMethodTests: XCTestCase {

    func testGetMethod() throws {
        XCTAssertEqual(HTTPMethod.get.method, "GET")
    }

    func testPostMethod() throws {
        XCTAssertEqual(HTTPMethod.post(Data()).method, "POST")
    }

}
