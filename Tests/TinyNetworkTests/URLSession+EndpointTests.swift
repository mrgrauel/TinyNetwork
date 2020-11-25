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

    var session: URLSession!
    var cancellables = Set<AnyCancellable>()

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

    override func setUpWithError() throws {
        session = URLSession(configuration: .default)
    }

    override class func tearDown() {
        MockDuck.unregisterAllRequestHandlers()
        MockDuck.shouldFallbackToNetwork = true
    }

    func testDataTaskResource() throws {
        let expectation = XCTestExpectation(description: "testDataTaskResource")

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/mock")
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

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/error")
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

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/invalidmock")
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

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/mock")
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

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/error")
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

        let endpoint = try DecodableEndpoint<MockResource>(domain: MockDomain.github, path: "/invalidmock")
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

private struct MockDomain: Domain {
    var host: String
    var scheme: String

    static var github: Self {
        MockDomain(host: "github.com", scheme: "https")
    }
}

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
