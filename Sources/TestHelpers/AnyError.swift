import Foundation

/// An equatable error.
///
/// This can be used to test that a service throws the error passed to one of its dependencies.
///
/// ```
/// func test_failingXXFetch_fetch_fails() async throws {
///     let error = AnyError()
///     let (sut, _) = makeSUT(xxFetchResult: .failure(error))
///
///     let capturedError = await captureError(from: try await sut.fetch())
///
///     XCTAssertNotNil(capturedError)
///     XCTAssertEqual(capturedError as? AnyError, error)
/// }
/// ```
public struct AnyError: Error, Equatable, Identifiable {
    public let id: UUID = .init()
}
