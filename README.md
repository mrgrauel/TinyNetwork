# TinyNetwork

![badge-mit][] ![badge-languages][] ![badge-pms][] ![badge-platforms][]

A tiny network library to fetch `Decodable` Resources or Images.

## Getting Started

We currently support [Swift Package Manager](https://swift.org/package-manager/)

### Swift Package Manager

Add **TinyNetwork** as a dependency to your Package.swift file. For more information, see the [Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

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
let request = Request<MockResource>(
    url: url,
    method: .get([
        .init(name: "foobar", value: "1"),
        .init(name: "barfoo", value: "2")
    ])
)

URLSession.shared.dataTaskPublisher(for: request)
    .sink(
        receiveCompletion: { completion in
            print(completion)
        },
        receiveValue: { value in
            print(value)
        }
    )
    .store(in: &cancellable)
```

## Help & Feedback

* [Open an issue](https://github.com/mrgrauel/TinyNetwork/issues/new) if you need help, if you found a bug, or if you want to discuss a feature request.
* [Open a PR](https://github.com/mrgrauel/TinyNetwork/pull/new/master) if you want to make some change to `TinyNetwork`.
* Contact [@mrgrauel](https://twitter.com/mrgrauel) on Twitter.

[badge-pms]: https://img.shields.io/badge/supports-SwiftPM-green.svg
[badge-languages]: https://img.shields.io/badge/languages-Swift-orange.svg
[badge-platforms]: https://img.shields.io/badge/platforms-iOS%20%7C%20watchOS-lightgrey.svg
[badge-mit]: https://img.shields.io/badge/license-MIT-blue.svg
