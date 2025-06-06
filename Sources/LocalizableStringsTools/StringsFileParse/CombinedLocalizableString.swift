//
//  LocalizableMerge.swift
//  AnyTest
//
//  Created by PandaEye on 2022/4/19.
//

/// 合并字符串后的结果。
public struct CombinedLocalizableString: Codable {

    public let description: String?
    public let key: String
    /// 记录多个value, 以locale为key区分。
    public let values: [String: String]
}
