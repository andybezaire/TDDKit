import XCTest
import TDDKit

final class CaptureErrorTests: XCTestCase {
    func test_failingFetchX_fetchY_fails() async throws {
        let error = AnyError()
        let (sut, _) = makeSUT(fetchXResult: .failure(error))

        let capturedError = await XCTCaptureError(from: try await sut.fetchY())

        XCTCastAssertEqual(capturedError, error)
    }

    func test_succedingBlock_captureError_fails() async throws {
        let block: () async throws -> Void = { }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: try await block())

        XCTAssertNil(capturedError)
    }

    func test_failingBlock_captureError_succeeds() async throws {
        let error = AnyError()
        let block: () async throws -> Void = { throw error }

        let capturedError = await XCTCaptureError(from: try await block())

        XCTCastAssertEqual(capturedError, error)
    }

    // MARK: - With message
    func test_succedingBlockWithMessage_captureError_fails() async throws {
        let block: () async throws -> Void = { }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: try await block(), "Added message")

        XCTAssertNil(capturedError)
    }

    // MARK: - helpers
    private func makeSUT(
        fetchXResult: Result<X, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: YService, spy: Spy) {
        let spy = Spy(fetchXResult: fetchXResult)
        let sut = XXYService(fetchX: spy.fetchX)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)
        return (sut, spy)
    }

    private final class Spy {
        enum Message { case fetchX }

        private let fetchXResult: Result<X, Error>

        init(fetchXResult: Result<X, Error>) {
            self.fetchXResult = fetchXResult
        }

        private(set) var messages: [Message] = []

        func fetchX() async throws -> X {
            messages.append(.fetchX)
            await Task.yield()
            return try fetchXResult.get()
        }
    }
}

// MARK: - production
private struct X { }

private struct Y { }
private protocol YService {
    func fetchY() async throws -> Y
}

private class XXYService: YService {
    private let fetchX: () async throws -> X

    init(fetchX: @escaping () async throws -> X) {
        self.fetchX = fetchX
    }

    func fetchY() async throws -> Y {
        let x = try await fetchX()
        return .init(x: x)
    }
}

private extension Y {
    init(x: X) {
        self.init()
    }
}
