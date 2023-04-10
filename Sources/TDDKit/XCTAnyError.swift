import Foundation
import XCTest

public extension XCTestCase {
    /// An equatable identifiable error.
    ///
    /// This can be used to test that a service throws the error passed to one of its dependencies.
    /// For example:
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() async throws {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    struct XCTAnyError: Error, Equatable, Identifiable {
        public let id: UUID

        public init(id: UUID = .init()) {
            self.id = id
        }
    }
}
