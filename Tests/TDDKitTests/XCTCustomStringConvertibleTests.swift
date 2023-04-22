import XCTest
import TDDKit

final class XCTCustomStringConvertibleTests: XCTestCase {
    func test_classInstance_description_succeeds() {
        let spy = Spy()
        let sut = Instance(port: spy)

        XCTAssertEqual("\(sut)", "Instance")
        XCTAssertEqual("\(spy)", "Spy")
    }

    // MARK: - helpers
    private class Spy: Port, XCTCustomStringConvertible {
        var circularReference: Suting?
    }
}

extension Instance: XCTCustomStringConvertible { }

// MARK: - production
private protocol Port { }
private protocol Suting { }
private class Instance: Suting {
    let port: Port
    init(port: Port) {
        self.port = port
    }
}

// MARK: - move to production
protocol XCTCustomStringConvertible: CustomStringConvertible { }
extension XCTCustomStringConvertible {
    var description: String {
        let reflection = Mirror(reflecting: self)
        return "\(reflection.subjectType)"
    }
}
