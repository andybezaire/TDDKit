import XCTest

public extension XCTestCase {
     func captureError<T>(from block: @autoclosure () async throws -> T) async -> Error? {
        var capturedError: Error?
        do {
            _ = try await block()
        } catch {
            capturedError = error
        }
        return capturedError
    }
}
