import XCTest
import TestHelpers

final class ExpectWillDeallocateInstanceTests: XCTestCase {
    func test_circularReference_example() throws {
        let spy = Instance()
        let sut = Instance(reference: spy)
        spy.reference = sut

        XCTExpectFailure()

        expectWillDeallocate(instance: sut)
        expectWillDeallocate(instance: spy)
    }

    func test_selfReferencing_example() throws {
        let sut = Instance()
        sut.reference = sut

        XCTExpectFailure()

        expectWillDeallocate(instance: sut)
    }

    private class Instance {
        var reference: Instance?
        init(reference: Instance? = nil) { self.reference = reference }
    }
}
