//
//  Task.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 18/11/23.
//

import Foundation

extension Task where Failure == Error {
    static func main(
        priority: TaskPriority? = nil,
        @_implicitSelfCapture _ operation: @escaping @MainActor () async throws -> Success
    ) {
        Task { @MainActor in
            try await operation()
        }
    }
}
