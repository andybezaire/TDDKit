import XCTest
import TDDKit

final class XCTCustomStringConvertibleTests: XCTestCase {
    func test_classInstance_description_succeeds() {
        let spy = Spy()
        let sut = Instance(port: spy)

        XCTAssertEqual("\(sut)", "Instance")
        XCTAssertEqual("\(spy)", "Spy")
    }

    func test_simpleEnums_description_succeeds() {
        let caseOne = Simple.one
        let caseTwo = Simple.two
        let caseThree = Simple.three

        XCTAssertEqual("\(caseOne)", ".one")
        XCTAssertEqual("\(caseTwo)", ".two")
        XCTAssertEqual("\(caseThree)", ".three")
    }

    func test_simpleEnumsAssert_description_succeeds() {
        let caseOne = Simple.one
        let caseTwo = Simple.two
        let caseThree = Simple.three

        XCTExpectFailure {
            XCTAssertEqual(Simple.one, .two)
            XCTAssertCountEqual([Simple.one], [.two])
            XCTAssertContainsEqual([Simple.one], [.two])
            XCTAssertCastEqual(Simple.one, Simple.two)
        }
    }

    // MARK: - helpers
    private class Spy: Port, XCTCustomStringConvertible {
        var circularReference: Suting?
    }
}

extension Instance: XCTCustomStringConvertible { }
extension Simple: XCTCustomStringConvertible { }

// MARK: - production
private protocol Port { }
private protocol Suting { }
private class Instance: Suting {
    let port: Port
    init(port: Port) {
        self.port = port
    }
}

private enum Simple: CaseIterable { case one, two, three }

// MARK: - move to production
protocol XCTCustomStringConvertible: CustomStringConvertible { }
extension XCTCustomStringConvertible {
    var description: String {
        if let caseName = getEnumCaseName(for: self) {
            return ".\(caseName)"
        } else {
            let reflection = Mirror(reflecting: self)
            return "\(reflection.subjectType)"
        }
    }

    // MARK: - helpers
    @_silgen_name("swift_EnumCaseName")
    private func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

    private func getEnumCaseName<T>(for value: T) -> String? {
        if let stringPtr = _getEnumCaseName(value) {
            return String(validatingUTF8: stringPtr)
        }
        return nil
    }
}
