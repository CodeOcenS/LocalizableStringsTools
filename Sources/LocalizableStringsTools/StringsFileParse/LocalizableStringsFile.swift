//
//  LocalizableMerge.swift
//  AnyTest
//
//  Created by PandaEye on 2022/4/19.
//

public struct LocalizableStringsFile {
    /// 路径
    public let locale: String
    /// 解析到的多语言 key value 备注
    public let localizableStrings: [LocalizableString]
}

extension LocalizableStringsFile{
    /// 合并两个 strings 文件， 用于处理相同存在相同 key 的合并， 以baseLocalizableStringsFile为基准
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
