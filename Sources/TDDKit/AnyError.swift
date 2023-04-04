import Foundation

/// An equatable identifiable error.
///
/// This can be used to test that a service throws the error passed to one of its dependencies.
/// For example:
/// ```
/// func test_failingFetchX_fetchY_fails() async throws {
///     let error = AnyError()
///     let (sut, _) = makeSUT(fetchXResult: .failure(error))
///
///     let capturedError = await XCTCaptureError(from: try await sut.fetchY())
///
///     XCTAssertNotNil(error)
///     XCTAssertEqual(capturedError as? AnyError, error)
/// }
/// ```
public struct AnyError: Error, Equatable, Identifiable {
    public let id: UUID

    public init(id: UUID = .init()) {
        self.id = id
    }
}
