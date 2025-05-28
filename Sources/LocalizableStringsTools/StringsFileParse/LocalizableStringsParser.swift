//
//  LocalizableMerge.swift
//  AnyTest
//
//  Created by PandaEye on 2022/4/19.
//
// 通过正则解析 Localizable.stings文件

import Foundation

open class LocalizableStringsParser {
    
    /// 从字符串中按照key value 的格式解析出 strings 多语言。
    ///
    /// 通过正则匹配解析出 key value， 缺陷，不能排除掉匹配以下多行注释情况。
    /// ```
    /// /*
    /// "key10" = "value10";
    /// */
    /// ```
    /// 还是会匹配到 key10
    /// - Parameters:
    ///   - string: 给定字符串
    ///   - locale: 路径
    /// - Returns: 解析信息
    public static func parse(string: String, locale: String) -> LocalizableStringsFile {
        let regex = try! NSRegularExpression(pattern: #"([\s\S]*?)\n[ ]*"(.*)"[ ]*=[ ]*"([\s\S]*?)"[ ]*;"#) // 该正则不能匹配首行不换行，
        var tempString = string
        var isAddNewLineToFirst = false
        if !tempString.hasSuffix("\n") {
            // 为了补足正则缺陷，自动添加一个换行
            tempString = "\n" + tempString
            isAddNewLineToFirst = true
        }
        
        let string = tempString as NSString
        let matches = regex.matches(in: string as String, range: string.range(of: string as String));
        var results = matches.map { match in
            let descriptionRange = match.range(at: 1)
            let keyRange = match.range(at: 2)
            let valueRange = match.range(at: 3)
            return LocalizableString.init(
                description: descriptionRange.length > 0 ? string.substring(with: descriptionRange) : nil,
                key: string.substring(with: keyRange),
                value: string.substring(with: valueRange)
            )
        }
        if isAddNewLineToFirst, let firstDesc = results.first?.description {
            // 去掉添加的第一个\n
            let newFirstDesc = firstDesc.replacingOccurrences(of: #"^\n"#, with: "", options: .regularExpression)
            let newFirst = LocalizableString(description: newFirstDesc, key: results.first!.key, value: results.first!.value)
            results[0] = newFirst
        }
        return .init(
            locale: locale,
            localizableStrings:results
        )
    }
}
