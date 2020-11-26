# TinyNetwork

A  tiny network library to fetch `Decodable` Resources or Images.

### Example

```swift
var cancellable = Set<AnyCancellable>()

public struct Mock: Decodable {
    public let name: String
}

let url = URL(string: "https://test.com/mock")!
let endpoint = DecodableEndpoint<Mock>(url: url)

URLSession.shared.dataTaskPublisher(for: endpoint)
    .sink( receiveCompletion: { completion in
        print(completion)
    },
    receiveValue: { value in
        print(value)
    })
    .store(in: &cancellable)
```
