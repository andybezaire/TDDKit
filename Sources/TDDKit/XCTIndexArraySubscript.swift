import XCTest

extension Array {
    public subscript(xctIndex index: Index, file: StaticString = #file, line: UInt = #line) -> Element? {
        guard indices.contains(index) else {
            XCTFail("index \(index) out of range \(startIndex) ..< \(endIndex).", file: file, line: line)
            return nil
        }

        return self[index]
    }
}