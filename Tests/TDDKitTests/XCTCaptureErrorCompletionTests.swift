import XCTest
import TDDKit

final class XCTCaptureErrorCompletionTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() async {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = await XCTCaptureError(from: { sut.createPoem(completion: $0) })

        XCTAssertCastEqual(capturedError, error)
    }

    func test_succedingBlock_captureError_capturesNil() async {
        let block: (@escaping (Result<Void, Error>) -> Void) -> Void = { $0(.success(())) }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: block)

        XCTAssertNil(capturedError)
    }

    func test_failingBlock_captureError_succeeds() async {
        let error = XCTAnyError()
        let block: (@escaping (Result<Void, Error>) -> Void) -> Void = { $0(.failure(error)) }

        let capturedError = await XCTCaptureError(from: block)

        XCTAssertCastEqual(capturedError, error)
    }

    // MARK: - With message
    func test_succedingBlockWithMessage_captureError_fails() async {
        let block: (@escaping (Result<Void, Error>) -> Void) -> Void = { $0(.success(())) }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: block, "Added message")

        XCTAssertNil(capturedError)
    }

    // MARK: - helpers
    private func makeSUT(
        getUsernameResult: Result<String, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PoemCreatorCompletion, spy: Spy) {
        let spy = Spy(getUsernameResult: getUsernameResult)
        let sut = OUATPoemCreatorCompletion(service: spy)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)

        return (sut, spy)
    }

    private final class Spy: UserService, UserServiceDefaults {
        enum Message { case getUsername }

        private let getUsernameResult: Result<String, Error>

        init(getUsernameResult: Result<String, Error>) {
            self.getUsernameResult = getUsernameResult
        }

        private(set) var messages: [Message] = []

        // MARK: - UserService
        func getUsername() async throws -> String {
            messages.append(.getUsername)
            await Task.yield()
            return try getUsernameResult.get()
        }
    }
}

// MARK: - production
protocol PoemCreatorCompletion {
    func createPoem(completion: @escaping (Result<String, Error>) -> Void)
}

class OUATPoemCreatorCompletion {
    private let service: UserService

    init(service: UserService) {
        self.service = service
    }
}

extension OUATPoemCreatorCompletion: PoemCreatorCompletion {
    func createPoem(completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let name = try await service.getUsername()
                completion(.success("Once upon a time... there was a \(name)"))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
