//
//  CKQueryOperation+Async.swift
//  Clean Kitchen
//
//  Created by Evan Coleman on 11/30/21.
//

import CloudKit

public extension CKQueryOperation {
    func fetchRecords(from database: CKDatabase) async throws -> (cursor: Cursor?, records: [Result<CKRecord, Error>]) {

        return try await withCheckedThrowingContinuation { continuation in
            var records: [Result<CKRecord, Error>] = []

            queryResultBlock = { result in
                switch result {
                case .success(let cursor):
                    continuation.resume(returning: (cursor, records))
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }

            recordMatchedBlock = { _, result in
                records.append(result)
            }

            database.add(self)
        }
    }
}
