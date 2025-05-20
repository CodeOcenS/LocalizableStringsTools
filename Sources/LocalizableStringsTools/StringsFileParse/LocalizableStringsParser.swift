//
//  LocalizableMerge.swift
//  AnyTest
//
//  Created by PandaEye on 2022/4/19.
//
// 通过正则解析 Localizable.stings文件

import Foundation

open class LocalizableStringsParser {

    public static func parse(string: String, locale: String) -> LocalizableStringsFile {
        let string = string as NSString
        // #"(?:\/\*\ (.*)\ \*\/\n)?"(.*)"\ =\ "(.*)";"#)
        //#"([^;]{0,})\n[ ]{0,}"(.*)"[ ]{0,}=[ ]{0,}"(.*)"[ ]{0,};"#) // 无法匹配换行 value
        let regex = try! NSRegularExpression(pattern: #"([\s\S]*?)\n[ ]*"(.*)"[ ]*=[ ]*"([\s\S]*?)"[ ]*;"#) // 目前无法匹配首行不换行
        
        return .init(
            locale: locale,
            localizableStrings: regex.matches(in: string as String, range: string.range(of: string as String)).map { match in
                let descriptionRange = match.range(at: 1) 
                let keyRange = match.range(at: 2)
                let valueRange = match.range(at: 3)
                return .init(
                    description: descriptionRange.length > 0 ? string.substring(with: descriptionRange) : nil,
                    key: string.substring(with: keyRange),
                    value: string.substring(with: valueRange)
                )
            }
        )
    }

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
