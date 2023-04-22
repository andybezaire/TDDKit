import XCTest
import TDDKit

final class XCTAssertWillDeallocateInstanceTests: XCTestCase {
    func test_circularReference_example() throws {
        let spy = Instance()
        let sut = Instance(reference: spy)
        spy.reference = sut

        XCTExpectFailure()
        XCTAssertWillDeallocate(instance: sut)
        XCTAssertWillDeallocate(instance: spy)
    }

    func test_selfReferencing_example() throws {
        let sut = Instance()
        sut.reference = sut

        XCTExpectFailure()
        XCTAssertWillDeallocate(instance: sut)
    }

    // MARK: - helpers
    private class Instance: XCTCustomDebugStringConvertible {
        var reference: Instance?
        init(reference: Instance? = nil) { self.reference = reference }
    }
}
