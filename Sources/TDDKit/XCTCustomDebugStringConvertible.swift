/// Nicely debug print just the class name or enum case
///
/// - Note: Does not handle nested enums.
/// [Feature request](https://github.com/andybezaire/TDDKit/issues) if needed.
/// - Note: Uses the `@_silgen_name` property wrapper.
public protocol XCTCustomDebugStringConvertible: CustomDebugStringConvertible { }

public extension XCTCustomDebugStringConvertible {
    var debugDescription: String {
        if let caseName = getEnumCaseName(for: self) {
            let reflection = Mirror(reflecting: self)

            guard reflection.displayStyle == .enum,
                  let associated = reflection.children.first else { return ".\(caseName)" }

            let value: String
            switch associated.value {
            case is String?:
                value = "\(associated.value)"
            case is String:
                value = "\"\(associated.value)\""
            default:
                value = "\(associated.value)"
            }

            let isBracketted = value.first == "(" && value.last == ")"
            let associatedValues = isBracketted ? String(value.dropFirst().dropLast(1)) : value

            return ".\(caseName)(\(associatedValues))"
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
