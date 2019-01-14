# Swift Generic JSON Type

This package provides a simple container for any JSON-data, that conforms to the `Codable` protocol.

Use this when you want to send the result of a function returning JSON-data as a `Decodable`, to another function accepting JSON-data as an `Encodable`; e.g. if you want to send the result of [`Marionette`'s `evaluate`](https://github.com/LinusU/Marionette) to a [JSBridge function](https://github.com/LinusU/JSBridge).

## Installation

### SwiftPM

```swift
dependencies: [
    .package(url: "https://github.com/LinusU/GenericJSONType", from: "1.0.0"),
]
```

### Carthage

```text
github "LinusU/GenericJSONType" ~> 1.0.0
```

## Usage

```swift
import GenericJSONType

let myJSONString = " ~~ any valid JSON string here ~~ ".data(using: .utf8)!

let decoder = JSONDecoder()
let decoded = try decoder.decode(JSON.self, from: myJSONString)

// `decoded` is now a structure representing the JSON data

let encoder = JSONEncoder()
let encoded = try encoder.encode(decoded)

// `encoded` is now a JSON representation of the data we started out with
```

## Hacking

The Xcode project is generated automatically from `project.yml` using [XcodeGen](https://github.com/yonaskolb/XcodeGen). It's only checked in because Carthage needs it, do not edit it manually.

```sh
$ mint run yonaskolb/xcodegen
💾  Saved project to GenericJSONType.xcodeproj
```
