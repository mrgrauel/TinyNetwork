# TinyNetwork

![badge-mit][] ![badge-languages][] ![badge-pms][] ![badge-platforms][]

A tiny network library to fetch `Decodable` Resources or Images.

### Getting Started

We only support [Swift Package Manager](https://swift.org/package-manager/)

#### Swift Package Manager

```swift
.package(url: "https://github.com/mrgrauel/TinyNetwork.git", from: "1.0.0")
```

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

[badge-pms]: https://img.shields.io/badge/supports-SwiftPM-green.svg
[badge-languages]: https://img.shields.io/badge/languages-Swift-orange.svg
[badge-platforms]: https://img.shields.io/badge/platforms-iOS%20%7C%20watchOS-lightgrey.svg
[badge-mit]: https://img.shields.io/badge/license-MIT-blue.svg
