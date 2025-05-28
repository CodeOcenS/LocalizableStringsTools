//
//  LocalizableStringsFile.swift
//  LocalizableStringsTools
//
//  Created by PandaEye on 2022/4/19.
//
//  本文件定义了用于表示本地化字符串文件的数据结构和相关操作方法。
//  主要功能包括存储本地化字符串信息和合并多个语言文件。

/// 表示一个本地化字符串文件，包含语言标识和所有本地化字符串条目。
/// 用于存储从 .strings 文件解析出的所有本地化键值对和注释信息。
public struct LocalizableStringsFile {
    /// 语言标识符，例如 "en"、"zh-Hans" 等，通常对应文件路径中的语言代码。
    public let locale: String
    
    /// 解析到的所有本地化字符串条目，每个条目包含 key、value 和可选的注释。
    /// 每个元素都是一个 LocalizableString 实例，表示 .strings 文件中的一个键值对。
    public let localizableStrings: [LocalizableString]
}

extension LocalizableStringsFile {
    /// 合并多个语言的 strings 文件，将相同 key 的不同语言版本合并到一起。
    /// 
    /// 该方法以 baseLocalizableStringsFile 为基准，查找其他语言文件中相同 key 的值，
    /// 并将它们合并到一个 CombinedLocalizableString 中，其中包含所有语言版本的值。
    /// 如果某个语言文件中不存在对应的 key，则该语言在结果中不会有对应的值。
    ///
    /// - Parameters:
    ///   - localizableStringsFiles: 要合并的其他语言文件数组
    ///   - baseLocalizableStringsFile: 基准语言文件，决定最终结果包含哪些 key
    /// - Returns: 合并后的多语言字符串数组，每个元素包含一个 key 的所有语言版本
    public static func merge(_ localizableStringsFiles: [LocalizableStringsFile],
                             to baseLocalizableStringsFile: LocalizableStringsFile) -> [CombinedLocalizableString] {
        var combinedLocalizableStrings: [CombinedLocalizableString] = []
        for baseLocalizableString in baseLocalizableStringsFile.localizableStrings {
            var values = [baseLocalizableStringsFile.locale: baseLocalizableString.value]
            for localizableStringsFile in localizableStringsFiles {
                if let localizableString = localizableStringsFile.localizableStrings.first(where: { $0.key == baseLocalizableString.key }) {
                    values[localizableStringsFile.locale] = localizableString.value
                }
            }
            combinedLocalizableStrings.append(.init(description: baseLocalizableString.description, key: baseLocalizableString.key, values: values))
        }
        return combinedLocalizableStrings
    }
}
