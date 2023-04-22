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

        XCTExpectFailure {
            XCTAssertEqual(caseOne, caseTwo)
            XCTAssertCountEqual([caseOne], [caseTwo])
            XCTAssertContainsEqual([caseOne], [caseTwo])
            XCTAssertCastEqual(caseOne, caseTwo)
        }
    }

    func test_complexEnums_description_succeeds() {
        let caseFirst = Complex.first
        let caseSecond = Complex.second("Second case")
        let caseThird = Complex.third(34, "Number and string")
        let caseFourth = Complex.fourth
        let caseFifth = Complex.fifth(45)
        let caseSecondNil = Complex.second(nil)

        XCTAssertEqual("\(caseFirst)", ".first")
        XCTAssertEqual("\(caseSecond)", #".second(Optional("Second case"))"#)
        XCTAssertEqual("\(caseThird)", #".third(34, "Number and string")"#)
        XCTAssertEqual("\(caseFourth)", ".fourth")
        XCTAssertEqual("\(caseFifth)", ".fifth(45)")
        XCTAssertEqual("\(caseSecondNil)", #".second(nil)"#)
    }

    func test_complexEnumsAssert_description_succeeds() {
        let caseFirst = Complex.first
        let caseSecond = Complex.second("Second case")
        let caseThird = Complex.third(34, "Number and string")
        let caseFourth = Complex.fourth
        let caseFifth = Complex.fifth(45)
        let caseSecondNil = Complex.second(nil)

        XCTExpectFailure {
            XCTAssertEqual(caseFirst, caseFourth)
            XCTAssertCountEqual([caseFirst], [caseFourth])
            XCTAssertContainsEqual([caseFirst], [caseFourth])
            XCTAssertCastEqual(caseFirst, caseFourth)
        }

        XCTExpectFailure {
            XCTAssertEqual(caseSecond, caseFourth)
            XCTAssertCountEqual([caseSecond], [caseFourth])
            XCTAssertContainsEqual([caseSecond], [caseFourth])
            XCTAssertCastEqual(caseSecond, caseFourth)
        }

        XCTExpectFailure {
            XCTAssertEqual(caseThird, caseFourth)
            XCTAssertCountEqual([caseThird], [caseFourth])
            XCTAssertContainsEqual([caseThird], [caseFourth])
            XCTAssertCastEqual(caseThird, caseFourth)
        }

        XCTExpectFailure {
            XCTAssertEqual(caseSecond, caseThird)
            XCTAssertCountEqual([caseSecond], [caseThird])
            XCTAssertContainsEqual([caseSecond], [caseThird])
            XCTAssertCastEqual(caseSecond, caseThird)
        }

        XCTExpectFailure {
            XCTAssertEqual(caseSecondNil, caseFifth)
            XCTAssertCountEqual([caseSecondNil], [caseFifth])
            XCTAssertContainsEqual([caseSecondNil], [caseFifth])
            XCTAssertCastEqual(caseSecondNil, caseFifth)
        }
    }

    // MARK: - helpers
    private class Spy: Port, XCTCustomDebugStringConvertible {
        var circularReference: Suting?
    }
}

extension Instance: XCTCustomDebugStringConvertible { }
extension Simple: XCTCustomDebugStringConvertible { }
extension Complex: XCTCustomDebugStringConvertible { }

// MARK: - production
private protocol Port { }
private protocol Suting { }
private class Instance: Suting {
    let port: Port
    init(port: Port) {
        self.port = port
    }
}

private enum Simple { case one, two, three }
private enum Complex: Equatable { case first, second(String?), third(Int, String), fourth, fifth(Int) }
