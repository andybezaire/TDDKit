import XCTest

final class XCTAssertContainsEqualTests: XCTestCase {
    func test_createPoem_callsServices() async throws {
        let (sut, spy) = makeSUT()

        _ = try await sut.createPoem()

        XCTAssertContainsEqual(spy.messages, [.getAge, .getUsername])
        XCTExpectFailure {
            XCTAssertEqual(spy.messages, [.getAge, .getUsername])
        }
    }

    func test_equal_succeeds() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three"].shuffled()

        XCTAssertContainsEqual(sut, sample)
    }

    func test_missingOne_showsMissingElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "three"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_missingTwo_showsMissingElements() {
        let sample = ["one", "two", "three"]

        let sut = ["three"]

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_oneExtra_showsExtraElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three", "four"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_twoExtra_showsExtraElements() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three", "four", "five"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_oneExtraOneMissing_showsExtraAndMissingElements() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "three", "four"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_twoExtraTwoMissing_showsExtraAndMissingElements() {
        let sample = ["one", "two", "three"]

        let sut = ["three", "four", "five"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    // MARK: - with message
    func test_missingWithMessage_showsMissingElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "three"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample, "Added message")
        }
    }

    func test_extraWithMessage_showsExtraElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three", "four"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample, "Added message")
        }
    }

    func test_extraAndMissing_showsExtraAndMissingElements() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "three", "four"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample, "Added message")
        }
    }

    // MARK: - helpers
    private func makeSUT(
        getUsernameResult: Result<String, Error> = .success("Some Username"),
        getAgeResult: Result<Int, Error> = .success(.random(in: 8 ... 99)),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PoemCreator, spy: Spy) {
        let spy = Spy(getUsernameResult: getUsernameResult, getAgeResult: getAgeResult)
        let sut = AgeSpecificPoemCreator(service: spy)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)

        return (sut, spy)
    }

    private final class Spy: UserService {
        enum Message: CustomStringConvertible {
            case getUsername, getAge
            var description: String {
                switch self {
                case .getUsername: return "getUsername"
                case .getAge: return "getAge"
                }
            }
        }

        private let getUsernameResult: Result<String, Error>
        private let getAgeResult: Result<Int, Error>

        init(getUsernameResult: Result<String, Error>, getAgeResult: Result<Int, Error>) {
            self.getUsernameResult = getUsernameResult
            self.getAgeResult = getAgeResult
        }

        private(set) var messages: [Message] = []

        // MARK: - UserService
        func getUsername() async throws -> String {
            messages.append(.getUsername)
            await Task.yield()
            return try getUsernameResult.get()
        }

        func getAge() async throws -> Int {
            messages.append(.getAge)
            await Task.yield()
            return try getAgeResult.get()
        }
    }
}

// MARK: - production
class AgeSpecificPoemCreator {
    private let service: UserService

    init(service: UserService) {
        self.service = service
    }
}

extension AgeSpecificPoemCreator: PoemCreator {
    func createPoem() async throws -> String {
        let name = try await service.getUsername()
        let age = try await service.getAge()

        switch age {
        case .min ..< 18:
            return "Once upon a time..."
        case 65 ... .max:
            return "Thou hast upon a sonnet for \(name)"
        default:
            return "Once upon a time... there was a \(name)"
        }
    }
}
