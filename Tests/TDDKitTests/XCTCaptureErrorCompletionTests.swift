import XCTest
import TDDKit

final class XCTCaptureErrorCompletionTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() async {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = await XCTCaptureError(from: { sut.createPoem(completion: $0) })

        XCTAssertCastEqual(capturedError, error)
    }

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

public extension XCTestCase {
    typealias ResultCompletion<T, Failure> = (Result<T, Failure>) -> Void where Failure: Error
    /// Capture the error from function that completes with a `Result`.
    ///
    /// This function will return the error from a throwing call.
    /// If no error was thrown, it will record a test failure.
    ///
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() async {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = await XCTCaptureError(from: { sut.createPoem(completion: $0) })
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - resultCompletionBlock: The function call under test that completes with a `Result`.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    /// - Returns: The error thrown from the block or nil if no error thrown.
    /// If no error is thrown, the function will record a test failure.
     func XCTCaptureError<T, Failure>(
        from resultCompletionBlock: @escaping (@escaping ResultCompletion<T, Failure>) -> Void,
        _ message: @escaping @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) async -> Failure? where Failure: Error {
         await withCheckedContinuation { continuation in
             resultCompletionBlock { result in
                 switch result {
                 case .success:
                     let description = ["XCTCaptureError failed: should have thrown an error", message()]
                         .filter { !$0.isEmpty }
                         .joined(separator: " - ")
                     let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                     self.record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                     continuation.resume(returning: nil)
                 case let .failure(error):
                     continuation.resume(returning: error)
                 }
             }
         }
    }
}
