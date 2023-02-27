import XCTest

extension Array {
    public subscript(index index: Index, file: StaticString = #file, line: UInt = #line) -> Element? {
        guard indices.contains(index) else {
            XCTFail("Index \(index) out of range \(startIndex) ..< \(endIndex).", file: file, line: line)
            return nil
        }

        return self[index]
    }
}
