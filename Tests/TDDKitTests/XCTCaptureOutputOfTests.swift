import XCTest
import TDDKit

@MainActor
final class XCTCaptureOutputOfTests: XCTestCase {
    func test_failingFetch_refreshTitle_setsLoadingText() async throws {
        let (sut, _) = makeSUT(fetchTitleResult: .failure(XCTAnyError()))

        let capturedOutput = await XCTCaptureOutput(of: { sut.loadingText }, for: sut.$isLoading) {
            await sut.refreshTitle()
        }

        XCTAssertCountEqual(capturedOutput, ["Loading...", "Finished"])
    }

    func test_refreshTitle_setsLoadingText() async throws {
        let (sut, _) = makeSUT()

        let capturedOutput = await XCTCaptureOutput(of: { sut.loadingText }, for: sut.$isLoading) {
            await sut.refreshTitle()
        }

        XCTAssertCountEqual(capturedOutput, ["Loading...", "Finished"])
    }

    // MARK: - helpers
    private func makeSUT(
        fetchTitleResult: Result<String, Error> = .success("Title"),
        initialTitle: String? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ViewModel, spy: Spy) {
        let spy = Spy(fetchTitleResult: fetchTitleResult)
        let sut = ViewModel(service: spy, initialTitle: initialTitle)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)

        return (sut, spy)
    }

    private final class Spy: TitleService {
        enum Message { case fetchTitle }
        private let fetchTitleResult: Result<String, Error>

        init(fetchTitleResult: Result<String, Error>) {
            self.fetchTitleResult = fetchTitleResult
        }

        private(set) var messages: [Message] = []

        func fetchTitle() async throws -> String {
            messages.append(.fetchTitle)
            await Task.yield()
            return try fetchTitleResult.get()
        }
    }
}

// MARK: - production
private protocol TitleService {
    func fetchTitle() async throws -> String
}

@MainActor
private final class ViewModel: ObservableObject {
    private let service: TitleService

    init(service: TitleService, initialTitle: String? = nil) {
        self.service = service
        self.title = initialTitle ?? ""
    }

    @Published private(set) var title: String
    @Published private(set) var isLoading: Bool = false

    var loadingText: String { isLoading ? "Loading..." : "Finished" }

    func refreshTitle() async {
        isLoading = true
        title = (try? await service.fetchTitle()) ?? ""
        isLoading = false
    }
}

// MARK: - move to production
import Combine
extension XCTestCase {
    /// A helper function to test that a variable gets the correct values when the publisher it is based on publishes.
    ///
    /// This helper is useful to TDD a view model or flow to add state changes for an action.
    ///
    /// ```
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
