import XCTest
import TDDKit

final class SampleUseTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() async throws {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = await XCTCaptureError(from: try await sut.createPoem())

        XCTAssertCastEqual(capturedError, error)
    }

    func test_createPoem_callsService() async throws {
        let (sut, spy) = makeSUT()

        _ = try await sut.createPoem()

        XCTAssertContainsEqual(spy.messages, [.getUsername])
    }

    func test_createPoem_succeeds() async throws {
        let name = UUID().uuidString
        let (sut, _) = makeSUT(getUsernameResult: .success(name))

        let capturedPoem = try await sut.createPoem()

        XCTAssertContainsEqual(capturedPoem, "Once upon a time... there was a \(name)")
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

    private final class Spy: XCTCustomDebugStringConvertible, UserService, UserServiceDefaults {
        enum Message: XCTCustomDebugStringConvertible { case getUsername }

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
