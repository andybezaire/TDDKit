import XCTest

final class XCTCaptureErrorSynchronousTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = XCTCaptureError(from: try sut.createPoem())

        XCTAssertCastEqual(capturedError, error)
    }

    func test_succedingBlock_captureError_capturesNil() {
        let block: () throws -> Void = { }

        XCTExpectFailure()
        let capturedError = XCTCaptureError(from: try block())

        XCTAssertNil(capturedError)
    }

//    func test_failingBlock_captureError_succeeds() async throws {
//        let error = XCTAnyError()
//        let block: () async throws -> Void = { throw error }
//
//        let capturedError = await XCTCaptureError(from: try await block())
//
//        XCTAssertCastEqual(capturedError, error)
//    }

    // MARK: - With message
//    func test_succedingBlockWithMessage_captureError_fails() async throws {
//        let block: () async throws -> Void = { }
//
//        XCTExpectFailure()
//        let capturedError = await XCTCaptureError(from: try await block(), "Added message")
//
//        XCTAssertNil(capturedError)
//    }

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


public extension XCTestCase {
    /// Capture the error from a throwing function call.
    ///
    /// This function will return the error from a throwing call.
    /// If no error was thrown, it will record a test failure.
    ///
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = XCTCaptureError(from: try sut.createPoem())
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - block: The function call under test.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    /// - Returns: The error thrown from the block or nil if no error thrown.
     func XCTCaptureError<T>(
        from block: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) -> Error? {
        do {
            _ = try block()
            let description = ["XCTCaptureError failed: should have thrown an error", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
            return nil
        } catch {
            return error
        }
    }
}
