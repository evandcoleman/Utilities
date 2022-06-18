//
//  CKRecord+Codable.swift
//  
//
//  Created by Evan Coleman on 6/13/22.
//

import CloudKit
import Foundation

public typealias CloudCodable = CloudEncodable & CloudDecodable

// MARK: - Encoding

public protocol CloudEncodable: Encodable {
    static var recordType: String { get }

    var cloudRecordName: String { get }
}

public final class CKEncoder {

    public init() {}

    public func encode<T: CloudEncodable>(_ value: T) throws -> CKRecord {
        let encoder = _CKEncoder<T>(recordName: value.cloudRecordName)
        try value.encode(to: encoder)
        return encoder.record
    }
}

final class _CKEncoder<T: CloudEncodable> {
    var recordName: String
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]

    var record: CKRecord { container!.record }

    fileprivate var container: CKEncodingContainer?

    init(recordName: String) {
        self.recordName = recordName
    }
}

extension _CKEncoder {
    final class KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var record: CKRecord

        init(recordName: String, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.record = CKRecord(recordType: T.recordType, recordID: .init(recordName: recordName))
        }
    }
}

extension _CKEncoder: Encoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        assertCanCreateContainer()

        let container = KeyedContainer<Key>(recordName: self.recordName, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container

        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }
}

extension _CKEncoder.KeyedContainer {
    func encodeNil(forKey key: Key) throws {
        record[key.stringValue] = nil
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        record[key.stringValue] = value as? CKRecordValue
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func superEncoder() -> Encoder {
        fatalError()
    }

    func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}

protocol CKEncodingContainer: AnyObject {
    var record: CKRecord { get }
}

extension _CKEncoder.KeyedContainer: CKEncodingContainer {}

// MARK: - Decoding

public protocol CloudDecodable: Decodable {}

final public class CKDecoder {

    public init() {}
    
    public func decode<T>(_ type: T.Type, from record: CKRecord) throws -> T where T: Decodable {
        let decoder = _CKDecoder(record: record)
        return try T(from: decoder)
    }
}

final class _CKDecoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var record: CKRecord

    var container: CKDecodingContainer?

    init(record: CKRecord) {
        self.record = record
    }
}

extension _CKDecoder: Decoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key: CodingKey {
        assertCanCreateContainer()

        let container = KeyedContainer<Key>(record: self.record, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container

        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() -> SingleValueDecodingContainer {
        fatalError()
    }
}

protocol CKDecodingContainer: AnyObject {

}

extension _CKDecoder {
    final class KeyedContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var record: CKRecord

        init(record: CKRecord, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
            self.record = record
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _CKDecoder.KeyedContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
        return record
            .allKeys()
            .compactMap { .init(stringValue: $0) }
    }

    func contains(_ key: Key) -> Bool {
//        guard key.stringValue != _CKSystemFieldsKeyName else { return true }

        return allKeys
            .contains(where: { $0.stringValue == key.stringValue })
    }

    func decodeNil(forKey key: Key) throws -> Bool {
//        if key.stringValue == _CKSystemFieldsKeyName {
//            return systemFieldsData.count == 0
//        } else {
            return record[key.stringValue] == nil
//        }
    }

    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
//        if key.stringValue == _CKSystemFieldsKeyName {
//            return systemFieldsData as! T
//        }
//
//        if key.stringValue == _CKIdentifierKeyName {
//            return record.recordID.recordName as! T
//        }

        // Bools are encoded as Int64 in CloudKit
        if type == Bool.self {
            return try decodeBool(forKey: key) as! T
        }

        // URLs are encoded as String (remote) or CKAsset (file URL) in CloudKit
        if type == URL.self {
            return try decodeURL(forKey: key) as! T
        }

        guard let value = record[key.stringValue] as? T else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "CKRecordValue couldn't be converted to \(String(describing: type))'")
            throw DecodingError.typeMismatch(type, context)
        }

        return value
    }

    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }

    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }

    private func decodeBool(forKey key: Key) throws -> Bool {
        guard let intValue = record[key.stringValue] as? Int64 else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Bool should have been encoded as Int64 in CKRecord")
            throw DecodingError.typeMismatch(Bool.self, context)
        }

        return intValue == 1
    }

    private func decodeURL(forKey key: Key) throws -> URL {
        guard let str = record[key.stringValue] as? String else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "URL should have been encoded as String in CKRecord")
            throw DecodingError.typeMismatch(URL.self, context)
        }

        guard let url = URL(string: str) else {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "The string \(str) is not a valid URL")
            throw DecodingError.typeMismatch(URL.self, context)
        }

        return url
    }
}

extension _CKDecoder.KeyedContainer: CKDecodingContainer {}
