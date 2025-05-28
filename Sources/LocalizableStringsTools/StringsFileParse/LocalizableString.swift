//
//  LocalizableString.swift
//  LocalizableStringsParser
//

public struct LocalizableString: Equatable {
    /// 备注或描述，在 key-value之前的。
    public let description: String?
    public let key: String
    public let value: String
    public static func == (lhs: LocalizableString, rhs: LocalizableString) -> Bool {
            return lhs.description == rhs.description &&
                   lhs.key == rhs.key &&
                   lhs.value == rhs.value
        }
}
