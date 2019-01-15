import XCTest
import GenericJSONType

final class GenericJSONTypeTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(JSON.null, JSON.null)
        XCTAssertEqual(JSON.boolean(true), JSON.boolean(true))
        XCTAssertEqual(JSON.boolean(false), JSON.boolean(false))
        XCTAssertEqual(JSON.number(1), JSON.number(1))
        XCTAssertEqual(JSON.number(1.23), JSON.number(1.23))
        XCTAssertEqual(JSON.string("Hello, World!"), JSON.string("Hello, World!"))
        XCTAssertEqual(JSON.array([.string("Hello, World!")]), JSON.array([.string("Hello, World!")]))
        XCTAssertEqual(JSON.object(["key": .string("Hello, World!")]), JSON.object(["key": .string("Hello, World!")]))
        XCTAssertEqual(JSON.array([.array([.array([.number(1)])])]), JSON.array([.array([.array([.number(1)])])]))

        XCTAssertNotEqual(JSON.null, JSON.boolean(true))
        XCTAssertNotEqual(JSON.boolean(true), JSON.boolean(false))
        XCTAssertNotEqual(JSON.number(1), JSON.number(2))
        XCTAssertNotEqual(JSON.number(1.23), JSON.number(1.24))
        XCTAssertNotEqual(JSON.string("Hello, World!"), JSON.string("Hello, Linus!"))
        XCTAssertNotEqual(JSON.array([.string("A"), .null]), JSON.array([.null, .string("A")]))
        XCTAssertNotEqual(JSON.object(["a": .string("Hello, World!")]), JSON.object(["b": .string("Hello, World!")]))
        XCTAssertNotEqual(JSON.object(["key": .string("Hello, World!")]), JSON.object(["key": .string("Hello, Linus!")]))
        XCTAssertNotEqual(JSON.array([.array([.array([.number(1)])])]), JSON.array([.array([.array([.number(2)])])]))
    }

    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let obj = JSON.object(["foo": .boolean(true), "bar": .string("A")])

        let data = try encoder.encode(obj)
        let decoded = try decoder.decode(JSON.self, from: data)

        XCTAssertEqual(obj, decoded)
    }

    func testDecodable() throws {
        let decoder = JSONDecoder()

        do {
            let input = "{\"foo\": true, \"bar\": \"A\"}".data(using: .utf8)!
            let expected = JSON.object(["foo": .boolean(true), "bar": .string("A")])
            let decoded = try decoder.decode(JSON.self, from: input)

            XCTAssertEqual(decoded, expected)
        }

        do {
            let input = "[[[1]]]".data(using: .utf8)!
            let expected = JSON.array([.array([.array([.number(1)])])])
            let decoded = try decoder.decode(JSON.self, from: input)

            XCTAssertEqual(decoded, expected)
        }

        do {
            let input = "[[[true]]]".data(using: .utf8)!
            let expected = JSON.array([.array([.array([.boolean(true)])])])
            let decoded = try decoder.decode(JSON.self, from: input)

            XCTAssertEqual(decoded, expected)
        }

        do {
            let input = "[{\"foo\": [{\"bar\": 1}]}]".data(using: .utf8)!
            let expected = JSON.array([.object(["foo": .array([.object(["bar": .number(1)])])])])
            let decoded = try decoder.decode(JSON.self, from: input)

            XCTAssertEqual(decoded, expected)
        }
    }

    func testReadmeExample() throws {
        let myJSONString = "[1,2,3,4,5]".data(using: .utf8)!

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(JSON.self, from: myJSONString)

        let encoder = JSONEncoder()
        let encoded = try encoder.encode(decoded)

        XCTAssertEqual(encoded, myJSONString)
    }
}
