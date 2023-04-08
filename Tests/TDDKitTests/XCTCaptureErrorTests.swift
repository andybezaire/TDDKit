import XCTest
import TDDKit

final class XCTCaptureErrorTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() async throws {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = await XCTCaptureError(from: try await sut.createPoem())

        XCTAssertCastEqual(capturedError, error)
    }

    func test_succedingBlock_captureError_capturesNil() async throws {
        let block: () async throws -> Void = { }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: try await block())

        XCTAssertNil(capturedError)
    }

    func test_failingBlock_captureError_succeeds() async throws {
        let error = XCTAnyError()
        let block: () async throws -> Void = { throw error }

        let capturedError = await XCTCaptureError(from: try await block())

        XCTAssertCastEqual(capturedError, error)
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
        getUsernameResult: Result<String, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PoemCreator, spy: Spy) {
        let spy = Spy(getUsernameResult: getUsernameResult)
        let sut = OUATPoemCreator(service: spy)

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
protocol PoemCreator {
    func createPoem() async throws -> String
}

protocol UserService {
    func getUsername() async throws -> String
    func getAge() async throws -> Int
}

protocol UserServiceDefaults { }
extension UserServiceDefaults {
    func getUsername() async throws -> String { fatalError() }
    func getAge() async throws -> Int { fatalError() }
}

class OUATPoemCreator {
    private let service: UserService

    init(service: UserService) {
        self.service = service
    }
}

extension OUATPoemCreator: PoemCreator {
    func createPoem() async throws -> String {
        let name = try await service.getUsername()
        return "Once upon a time... there was a \(name)"
    }
}
