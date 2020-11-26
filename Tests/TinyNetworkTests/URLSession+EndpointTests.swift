//
//  URLSession+EndpointTests.swift
//  TinyNetworkTests
//
//  Created by Andreas Osberghaus on 25.11.20.
//

import XCTest
import MockDuck
import Combine
@testable import TinyNetwork

class URLSessionEndpointTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!
    
    var session: URLSession!
    var url: URL!

    override class func setUp() {
        MockDuck.registerRequestHandler { urlRequest -> MockResponse? in
            let components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
            switch components.path {
            case "/mock":
                let data = try? JSONEncoder().encode(MockResource.sample)
                return try? MockResponse(for: urlRequest, data: data)
            case "/error":
                return nil
            case "/invalidmock":
                let data = try? JSONEncoder().encode(OtherMockResource.sample)
                return try? MockResponse(for: urlRequest, data: data)
            default:
                return nil
            }
        }
        MockDuck.shouldFallbackToNetwork = false
    }
    
    override func setUp() {
        cancellables = Set<AnyCancellable>()
    }
    
    override func setUpWithError() throws {
        session = URLSession(configuration: .default)
        url = try XCTUnwrap(URL(string: "https://github.com/"))
    }
    
    override func tearDown() {
        cancellables = nil
    }

    override class func tearDown() {
        MockDuck.unregisterAllRequestHandlers()
        MockDuck.shouldFallbackToNetwork = true
    }

    func testDataTaskResource() throws {
        let expectation = XCTestExpectation(description: "testDataTaskResource")

        let url = self.url.appendingPathComponent("mock")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        let dataTask = session.dataTask(with: endpoint) { result in
            switch result {
            case .failure:
                XCTFail("Should complete successfully")
            case let .success(resource):
                XCTAssertEqual(resource, MockResource.sample)
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3)
    }

    func testDataTaskResourceError() throws {
        let expectation = XCTestExpectation(description: "testDataTaskResourceError")

        let url = self.url.appendingPathComponent("error")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        let dataTask = session.dataTask(with: endpoint) { result in
            switch result {
            case let .failure(error):
                XCTAssert(error is URLError)
            case let .success(resource):
                XCTFail("the request should fail, but we got \(resource)")
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3)
    }

    func testDataTaskResourceInvalidMock() throws {
        let expectation = XCTestExpectation(description: "testDataTaskResourceInvalidMock")

        let url = self.url.appendingPathComponent("invalidmock")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        let dataTask = session.dataTask(with: endpoint) { result in
            switch result {
            case let .failure(error):
                XCTAssert(error is DecodingError)
            case let .success(resource):
                XCTFail("the request should fail, but we got \(resource)")
            }
            expectation.fulfill()
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 3)
    }

    func testDataTaskPublisherResource() throws {
        let expectation = XCTestExpectation(description: "dataTaskPublisherResource")

        let url = self.url.appendingPathComponent("mock")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        session.dataTaskPublisher(for: endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail("Should complete successfully")
                case .finished:
                    break
                }
                expectation.fulfill()
            }, receiveValue: { resource in
                XCTAssertEqual(resource, MockResource.sample)
            })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)
    }

    func testDataTaskPublisherResourceError() throws {
        let expectation = XCTestExpectation(description: "testDataTaskPublisherResourceError")

        let url = self.url.appendingPathComponent("error")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        session.dataTaskPublisher(for: endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTAssert(error is URLError)
                case .finished:
                    XCTFail("The publisher should fail.")
                }
                expectation.fulfill()
            }, receiveValue: { resource in
                XCTFail("the request should fail, but we got \(resource)")
            })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)
    }

    func testDataTaskPublisherResourceInvalidMock() throws {
        let expectation = XCTestExpectation(description: "testDataTaskPublisherResourceInvalidMock")
        
        let url = self.url.appendingPathComponent("invalidmock")
        let endpoint = DecodableEndpoint<MockResource>(url: url)
        session.dataTaskPublisher(for: endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTAssert(error is DecodingError)
                case .finished:
                    XCTFail("The publisher should fail.")
                }
                expectation.fulfill()
            }, receiveValue: { resource in
                XCTFail("the request should fail, but we got \(resource)")
            })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)
    }
}

// MARK: - Mocks

private struct MockResource: Codable, Equatable {
    let name: String

    static var sample: Self {
        MockResource(name: "foobar")
    }
}

private struct OtherMockResource: Codable {
    let fullname: String

    static var sample: Self {
        OtherMockResource(fullname: "barfoo")
    }
}
