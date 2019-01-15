import XCTest

extension GenericJSONTypeTests {
    static let __allTests = [
        ("testCodable", testCodable),
        ("testDecodable", testDecodable),
        ("testEncodable", testEncodable),
        ("testEquality", testEquality),
        ("testReadmeExample", testReadmeExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GenericJSONTypeTests.__allTests),
    ]
}
#endif
