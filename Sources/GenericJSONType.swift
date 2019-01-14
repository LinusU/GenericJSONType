fileprivate struct JSONKey: CodingKey {
    private(set) var stringValue: String

    public init(stringValue: String) {
        self.stringValue = stringValue
    }

    public init?(intValue: Int) {
        return nil
    }

    public var intValue: Int? {
        return nil
    }
}

public enum JSON: Equatable {
    case object([String: JSON])
    case array([JSON])
    case string(String)
    case number(Double)
    case boolean(Bool)
    case null
}

extension JSON: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .object(let object):
            var container = encoder.container(keyedBy: JSONKey.self)
            for (key, value) in object { try container.encode(value, forKey: JSONKey(stringValue: key)) }
        case .array(let array):
            var container = encoder.unkeyedContainer()
            for value in array { try container.encode(value) }
        case .string(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .number(let number):
            var container = encoder.singleValueContainer()
            try container.encode(number)
        case .boolean(let boolean):
            var container = encoder.singleValueContainer()
            try container.encode(boolean)
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}

extension JSON: Decodable {
    public init(from decoder: Decoder) throws {
        if var object = try? decoder.container(keyedBy: JSONKey.self) {
            try self.init(from: &object)
        } else if var array = try? decoder.unkeyedContainer() {
            try self.init(from: &array)
        } else if var value = try? decoder.singleValueContainer() {
            try self.init(from: &value)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: ""))
        }
    }

    private init(from container: inout KeyedDecodingContainer<JSONKey>) throws {
        var members = [String: JSON]()

        for key in container.allKeys {
            if var object = try? container.nestedContainer(keyedBy: JSONKey.self, forKey: key) {
                members[key.stringValue] = try .init(from: &object)
                continue
            }

            if var array = try? container.nestedUnkeyedContainer(forKey: key) {
                members[key.stringValue] = try .init(from: &array)
                continue
            }

            if let string = try? container.decode(String.self, forKey: key) {
                members[key.stringValue] = .string(string)
                continue
            }

            if let number = try? container.decode(Double.self, forKey: key) {
                members[key.stringValue] = .number(number)
                continue
            }

            if let boolean = try? container.decode(Bool.self, forKey: key) {
                members[key.stringValue] = .boolean(boolean)
                continue
            }

            if try container.decodeNil(forKey: key) {
                members[key.stringValue] = .null
                continue
            }

            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Failed to decode member of JSON object"))
        }

        self = .object(members)
    }

    private init(from container: inout UnkeyedDecodingContainer) throws {
        var elements = [JSON]()

        while !container.isAtEnd {
            if var object = try? container.nestedContainer(keyedBy: JSONKey.self) {
                elements.append(try .init(from: &object))
                continue
            }

            if var array = try? container.nestedUnkeyedContainer() {
                elements.append(try .init(from: &array))
                continue
            }

            if let string = try? container.decode(String.self) {
                elements.append(.string(string))
                continue
            }

            if let number = try? container.decode(Double.self) {
                elements.append(.number(number))
                continue
            }

            if let boolean = try? container.decode(Bool.self) {
                elements.append(.boolean(boolean))
                continue
            }

            if try container.decodeNil() {
                elements.append(.null)
                continue
            }

            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Failed to decode element of JSON array"))
        }

        self = .array(elements)
    }

    private init(from container: inout SingleValueDecodingContainer) throws {
        if let string = try? container.decode(String.self) {
            self = .string(string)
            return
        }

        if let number = try? container.decode(Double.self) {
            self = .number(number)
            return
        }

        if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
            return
        }

        if container.decodeNil() {
            self = .null
            return
        }

        throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Failed to decode single JSON value"))
    }
}
