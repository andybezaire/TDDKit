import Combine
import XCTest

public extension XCTestCase {
    /// Capture the output of a closure when an `@Published` publisher publishes.
    ///
    /// This function samples the closure value after the publisher has published
    /// and returns these samples in an array.
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
    /// > Note: As the publisher publishes on `objectWillChange` the closure's return value
    /// > will represent the previous published value.
    /// > Extra initial values are discarded by this function and a final value is appended to the end.
    ///
    /// - Parameters:
    ///   - closure: The closure that will output the correct values.
    ///   - publisher: The publisher that indicated when the closure should be sampled.
    ///   - dropCount: _Optional._ The number of initial values to drop. Defaults to 1,
    ///   as the `@Published`publisher will publish the initial value
    ///   and that often does not need to be considered.
    ///   - block: The action that should happen to cause the publisher to publish.
    /// - Returns: An array containing the sampled output of the closure.
    func XCTCaptureOutput<Publisher, Output>(
        of closure: @escaping () -> Output,
        for publisher: Publisher,
        droppingFirst dropCount: Int = 1,
        when block: () async -> Void
    ) async -> [Output] where Publisher: Combine.Publisher, Publisher.Failure == Never {
        var capturedOutput: [Output] = []

        let publishing = publisher
            .dropFirst(dropCount + 1)
            .sink { _ in capturedOutput.append(closure()) }
        await block()
        capturedOutput.append(closure())

        publishing.cancel()
        return capturedOutput
    }

}
