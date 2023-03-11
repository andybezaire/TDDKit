import XCTest
import TestHelpers

// MARK: - captureError

extension XCTestCase {
    func captureError(from block: () async throws -> Y) async -> Error? {
        var capturedError: Error?
        do {
            _ = try await block()
        } catch {
            capturedError = error
        }
        return capturedError
    }
}

final class CaptureErrorTests: XCTestCase {
    func test_failingFetchX_fetchY_fails() async throws {
        let error = AnyError()
        let (sut, _) = makeSUT(fetchXResult: .failure(error))

        var capturedError: Error?
        do {
            _ = try await sut.fetchY()
        } catch {
            capturedError = error
        }

        XCTAssertNotNil(error)
        XCTAssertEqual(capturedError as? AnyError, error)
    }

    // MARK: - helpers
    private func makeSUT(
        fetchXResult: Result<X, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: YService, spy: Spy) {
        let spy = Spy(fetchXResult: fetchXResult)
        let sut = XXYService(fetchX: spy.fetchX)

        expectWillDeallocate(instance: sut, file: file, line: line)
        expectWillDeallocate(instance: spy, file: file, line: line)
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
struct X { }

struct Y { }
protocol YService {
    func fetchY() async throws -> Y
}

class XXYService: YService {
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
