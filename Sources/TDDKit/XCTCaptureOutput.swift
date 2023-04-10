import Combine
import XCTest

public extension XCTestCase {
    /// Capture the output of an `@Published` publisher.
    ///
    /// This function returns an array of all of the `Output` values that the publisher has published.
    ///
    /// ```swift
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
    /// - Parameters:
    ///   - publisher: The publisher that should publish the correct values.
    ///   - dropCount: _Optional._ The number of initial values to drop. Defaults to 1,
    ///   as the `@Published`publisher will publish the initial value
    ///   and that often does not need to be considered.
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
