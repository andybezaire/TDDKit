import XCTest

final class XCTCaptureErrorSynchronousTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() throws {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = XCTCaptureError(from: try sut.createPoem())

        XCTAssertCastEqual(capturedError, error)
    }

    func test_succedingBlock_captureError_capturesNil() throws {
        let block: () throws -> Void = { }

        XCTExpectFailure()
        let capturedError = XCTCaptureError(from: try block())

        XCTAssertNil(capturedError)
    }

    func test_failingBlock_captureError_succeeds() throws {
        let error = XCTAnyError()
        let block: () throws -> Void = { throw error }

        let capturedError = XCTCaptureError(from: try block())

        XCTAssertCastEqual(capturedError, error)
    }

    // MARK: - With message
    func test_succedingBlockWithMessage_captureError_fails() throws {
        let block: () throws -> Void = { }

        XCTExpectFailure()
        let capturedError = XCTCaptureError(from: try block(), "Added message")

        XCTAssertNil(capturedError)
    }

    // MARK: - helpers
    private func makeSUT(
        getUsernameResult: Result<String, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PoemCreatorSynchronous, spy: Spy) {
        let spy = Spy(getUsernameResult: getUsernameResult)
        let sut = OUATPoemCreatorSynchronous(service: spy)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)

        return (sut, spy)
    }

    private final class Spy: UserServiceSynchronous, UserServiceSynchronousDefaults {
        enum Message { case getUsername }

        private let getUsernameResult: Result<String, Error>

        init(getUsernameResult: Result<String, Error>) {
            self.getUsernameResult = getUsernameResult
        }

        private(set) var messages: [Message] = []

        // MARK: - UserService
        func getUsername() throws -> String {
            messages.append(.getUsername)
            return try getUsernameResult.get()
        }
    }
}

// MARK: - production
protocol PoemCreatorSynchronous {
    func createPoem() throws -> String
}

protocol UserServiceSynchronous {
    func getUsername() throws -> String
    func getAge() throws -> Int
}

protocol UserServiceSynchronousDefaults { }
extension UserServiceSynchronousDefaults {
    func getUsername() throws -> String { fatalError() }
    func getAge() throws -> Int { fatalError() }
}

class OUATPoemCreatorSynchronous {
    private let service: UserServiceSynchronous

    init(service: UserServiceSynchronous) {
        self.service = service
    }
}

extension OUATPoemCreatorSynchronous: PoemCreatorSynchronous {
    func createPoem() throws -> String {
        let name = try service.getUsername()
        return "Once upon a time... there was a \(name)"
    }
}
