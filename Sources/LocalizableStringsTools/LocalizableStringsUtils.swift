//
//  File.swift
//  LocalizableStringsTools
//
//  Created by PandaEye on 2025/2/26.
//

import Foundation

public enum LocalizableStringsFindInsertIndexError: Error {
    /// 包含多个匹配
    case multipleMatches
    /// 没有匹配
    case noMatch
    /// 有多行注释 /*  */ 类型的，无法插入
    case multiLineComment
}


public class LocalizableStringsUtils {
    
}
@available(macOS 13.0, iOS 16.0, *)
public extension LocalizableStringsUtils {
    ///  查找插入 Index 位置（插入在这个位置之后）
    ///
    /// - Parameters:
    ///   - allStrings: 所有文本
    ///   - subStr: 子文本（匹配插入点）
    /// - Throws: ``LocalizableStringsFindInsertIndexError``
    /// - Returns: index: 插入位置， insertIndexHave2EmptyLine: 是插入位置后是否有两行空行
    class func findInsertIndex(allStrings: String, subStr: String) throws -> (index: String.Index?, insertIndexHave2EmptyLine: Bool) {
        let ranges = allStrings.ranges(of: subStr)
        if ranges.count > 1 {
            // 有超过多个匹配
            throw LocalizableStringsFindInsertIndexError.multipleMatches
        }
        if ranges.isEmpty {
            // 没有匹配
            throw LocalizableStringsFindInsertIndexError.noMatch
        }
        guard let upperBound = ranges.first?.upperBound else {
            throw LocalizableStringsFindInsertIndexError.noMatch
        }
        
        let suffixText = allStrings[upperBound...]
        let suffixArray = suffixText.components(separatedBy: CharacterSet.newlines)
        let text: String = suffixArray.first ?? "";
        guard !text.isEmpty else {
            return (upperBound, false)
        }
        
        if (text.trimmingCharacters(in: .whitespaces).hasPrefix("/*")) {
            // 有多行注释， 不添加
            throw LocalizableStringsFindInsertIndexError.multiLineComment
        } else {
            // 单行注释
            let insertIndex = allStrings.index(upperBound, offsetBy: text.count)
            var insertIndexHave2EmptyLine = false
            if suffixArray.count >= 3 , suffixArray[1].isEmpty , suffixArray[2].isEmpty {
                insertIndexHave2EmptyLine = true
            }
            return (insertIndex, insertIndexHave2EmptyLine)
            
        }
    }
    /// 替换特殊字符
    ///
    /// - 全角处理为半角：%、@、{、}
    /// - %s 替换为 %@
    /// - 处理value 中有引号问题
    static func replaceSpecial(_ text: String) -> String {
        var result: String = text
        // 将全角符号替换为半角
        result = result.replacingOccurrences(of: "％", with: "%")
        result = result.replacingOccurrences(of: "＠", with: "@")
        result = result.replacingOccurrences(of: "｛", with: "{")
        result = result.replacingOccurrences(of: "｝", with: "}")
        // %s 替换为 %@
        result = result.replacingOccurrences(of: "%s", with: "%@")
        // 处理value 中有引号问题
        guard let regularExpression = try? NSRegularExpression(pattern: #"(?<!\\)""#) else {
            return result
        }
        result = regularExpression.stringByReplacingMatches(in: result, range: NSRange(location: 0, length: result.count), withTemplate: #"\\\""#)
        return result
    }
}
