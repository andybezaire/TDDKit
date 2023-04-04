import XCTest
import TDDKit

@MainActor
final class XCTCaptureIsMainThreadTests: XCTestCase {
    func test_failingFetch_refreshTitle_publishesOnMainThread() async throws {
        let (sut, _) = makeSUT(fetchTitleResult: .failure(XCTError()))

        let capturedIsMainThread = await XCTCaptureIsMainThread(for: sut.$title) {
            await sut.refreshTitle()
        }

        XCTAssertEqual(capturedIsMainThread.count, 1)
        XCTAssertEqual(capturedIsMainThread[xctIndex: 0], true)
    }

    func test_refreshTitle_publishesOnMainThread() async throws {
        let (sut, _) = makeSUT()

        let capturedIsMainThread = await XCTCaptureIsMainThread(for: sut.$title) {
            await sut.refreshTitle()
        }

        XCTAssertEqual(capturedIsMainThread.count, 1)
        XCTAssertEqual(capturedIsMainThread[xctIndex: 0], true)
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
private class ViewModel: ObservableObject {
    private let service: TitleService

    init(service: TitleService, initialTitle: String? = nil) {
        self.service = service
        self.title = initialTitle ?? ""
    }

    @Published private(set) var title: String

    @Sendable func refreshTitle() async {
        title = (try? await service.fetchTitle()) ?? ""
    }
}
