import Foundation
import TinyNetwork
import MockDuck
import Combine
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

MockDuck.registerRequestHandler { urlRequest -> MockResponse? in
    let components = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
    switch components.path {
    case "/mock":
        let jsonURL = Bundle.main.url(forResource: "mock", withExtension: "json")
        return try? MockResponse(for: urlRequest, data: try! Data(contentsOf: jsonURL!, options: .mappedIfSafe) )
    default:
        return nil
    }
}

let url = URL(string: "https://test.com/mock")!
let endpoint = DecodableEndpoint<Mock>(url: url)
var cancellable = Set<AnyCancellable>()

URLSession.shared.dataTaskPublisher(for: endpoint)
    .sink( receiveCompletion: { completion in
        print(completion)
        PlaygroundPage.current.finishExecution()
    },
    receiveValue: { value in
        print(value)
    })
    .store(in: &cancellable)

