import XCTest

final class XCTCaptureErrorCompletionTests: XCTestCase {
//    func test_failingGetUsername_createPoem_fails() throws {
//        let error = XCTAnyError()
//        let (sut, _) = makeSUT(getUsernameResult: .failure(error))
//
//        let capturedError = XCTCaptureError(from: try sut.createPoem())
//
//        XCTAssertCastEqual(capturedError, error)
//    }

//    func test_succedingBlock_captureError_capturesNil() throws {
//        let block: () throws -> Void = { }
//
//        XCTExpectFailure()
//        let capturedError = XCTCaptureError(from: try block())
//
//        XCTAssertNil(capturedError)
//    }

//    func test_failingBlock_captureError_succeeds() throws {
//        let error = XCTAnyError()
//        let block: () throws -> Void = { throw error }
//
//        let capturedError = XCTCaptureError(from: try block())
//
//        XCTAssertCastEqual(capturedError, error)
//    }

    // MARK: - With message
//    func test_succedingBlockWithMessage_captureError_fails() throws {
//        let block: () throws -> Void = { }
//
//        XCTExpectFailure()
//        let capturedError = XCTCaptureError(from: try block(), "Added message")
//
//        XCTAssertNil(capturedError)
//    }

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
