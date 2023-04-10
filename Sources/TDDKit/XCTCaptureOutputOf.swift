import Combine
import XCTest

public extension XCTestCase {
    /// A helper function to test that a variable gets the correct values when the publisher it is based on publishes.
    ///
    /// This helper is useful to TDD a view model or flow to add state changes for an action.
    ///
    /// ```swift
    /// func test_refreshTitle_setsLoadingText() async throws {
    ///     let (sut, _) = makeSUT()
    ///
    ///     let capturedOutput = await XCTCaptureOutput(of: { sut.loadingText }, for: sut.$isLoading) {
    ///         await sut.refreshTitle()
    ///     }
    ///
    ///     XCTAssertCountEqual(capturedOutput, ["Loading...", "Finished"])
    /// }
    /// ```
    ///
    /// Please refer to the package tests for a complete example.
    /// - Parameters:
    ///   - closure: The closure that will output the correct values.
    ///   - publisher: The publisher that indicated when the closure should be sampled.
    ///   - dropCount: _Optional._ The number of initial values to drop. Defaults to 2,
    ///   as the @Publisher will publish the initial value and that often does not
    ///   need to be considered. It also publishes _before_ the value is updated.
    ///   This extra read before is removed and an extra read is done after the block.
    ///   - block: The action that should happen to cause the publisher to publish.
    /// - Returns: An array containing the sampled output of the closure.
    func XCTCaptureOutput<Publisher, Output>(
        of closure: @escaping () -> Output,
        for publisher: Publisher,
        droppingFirst dropCount: Int = 2,
        when block: () async -> Void
    ) async -> [Output] where Publisher: Combine.Publisher, Publisher.Failure == Never {
        var capturedOutput: [Output] = []

        let publishing = publisher
            .dropFirst(dropCount)
            .sink { _ in capturedOutput.append(closure()) }
        await block()
        capturedOutput.append(closure())

        publishing.cancel()
        return capturedOutput
    }

}
