import XCTest

extension GenericJSONTypeTests {
    static let __allTests = [
        ("testCodable", testCodable),
        ("testDecodable", testDecodable),
        ("testEquality", testEquality),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GenericJSONTypeTests.__allTests),
    ]
}
#endif
