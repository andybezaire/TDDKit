import Combine
import Foundation
import XCTest

public extension XCTestCase {
    /// A helper function to test that a publisher publishes on the main thread.
    ///
    /// This helper is useful to TDD a view model or flow to add publishes on main thread functionality.
    ///
    /// ```
    /// func test_refreshTitle_publishesOnMainThread() async throws {
    ///     let (sut, _) = makeSUT()
    ///
    ///     let capturedIsMainThread = await XCTCaptureIsMainThread(for: sut.$title) {
    ///         await sut.refreshTitle()
    ///     }
    ///
    ///     XCTAssertCountEqual(capturedIsMainThread, [true])
    /// }
    /// ```
    ///
    /// Please refer to the package tests for a complete example.
    /// - Parameters:
    ///   - publisher: The publisher that should publish on the main thread.
    ///   - dropCount: _Optional._ The number of initial values to drop. Defaults to 1,
    ///   as the @Publisher will publish the initial value and that often does not
    ///   need to happen on the main thread.
    ///   - block: The action that should happen to cause the publisher to publish.
    /// - Returns: An array of `Bool`s indicating if the publishes were on the main thread.
    func XCTCaptureIsMainThread<Publisher>(
        for publisher: Publisher,
        droppingFirst dropCount: Int = 1,
        when block: () async -> Void
    ) async -> [Bool] where Publisher: Combine.Publisher, Publisher.Failure == Never {
        var capturedIsMainThread: [Bool] = []

        let publishing = publisher
            .dropFirst(dropCount)
            .sink { _ in capturedIsMainThread.append(Thread.isMainThread) }

        await block()
        publishing.cancel()
        return capturedIsMainThread
    }
}