import Combine
import XCTest

public extension XCTestCase {
    /// A helper function to test that a publisher publishes the correct values.
    ///
    /// This helper is useful to TDD a view model or flow to add state changes for an action.
    ///
    /// ```
    /// func test_refreshTitle_setsIsLoading() async throws {
    ///     let (sut, _) = makeSUT()
    ///
    ///     let capturedOutput = await XCTCaptureOutput(for: sut.$isLoading) {
    ///         await sut.refreshTitle()
    ///     }
    ///
    ///     XCTAssertCountEqual(capturedOutput, [true, false])
    /// }
    /// ```
    ///
    /// Please refer to the package tests for a complete example.
    /// - Parameters:
    ///   - publisher: The publisher that should publish the correct values.
    ///   - dropCount: _Optional._ The number of initial values to drop. Defaults to 1,
    ///   as the @Publisher will publish the initial value and that often does not
    ///   need to be considered.
    ///   - block: The action that should happen to cause the publisher to publish.
    /// - Returns: An array containing the output of the publisher.
    func XCTCaptureOutput<Publisher, Output>(
        for publisher: Publisher,
        droppingFirst dropCount: Int = 1,
        when block: () async -> Void
    ) async -> [Output] where Publisher: Combine.Publisher, Publisher.Failure == Never, Publisher.Output == Output {
        var capturedOutput: [Output] = []

        let publishing = publisher
            .dropFirst(dropCount)
            .sink { capturedOutput.append($0) }

        await block()
        publishing.cancel()
        return capturedOutput
    }
}
