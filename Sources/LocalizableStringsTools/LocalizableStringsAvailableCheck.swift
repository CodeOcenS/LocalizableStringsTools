//
//  LocalizableStringsAvailableCheck.swift
//  LocalizableMerge
//
//  Created by PandaEye on 2025/5/26.
//

import Foundation
public struct LocalizableStringsAvailableCheck {
    /// 是否为 Excel 中的特殊错误值
    /// - Returns: 是否为特殊错误值
    ///
    ///| 错误码  | 含义                | 典型原因示例                     |
    ///| ------- | ------------------- | -------------------------------- |
    ///| #DIV/0! | 除以零错误          | 公式除数为0                      |
    ///| #N/A    | 无可用值            | 查找不到数据                     |
    ///| #VALUE! | 值类型错误          | 运算类型不匹配，如文本加数字     |
    ///| #REF!   | 无效引用            | 被引用的单元格被删除             |
    /// #NAME?  | 名称无效或拼写错误  | 函数/名称拼写错误或未定义        |
    ///| #NUM!   | 数值错误            | 数值非法或超出范围               |
    ///| #NULL!  | 空值错误            | 区域分隔符错误（如 A1:A3 B1:B3） |
    ///| #SPILL! | 溢出错误（新Excel） | 动态数组公式溢出                 |
    ///| #CALC!  | 计算错误（新Excel） | 公式逻辑无法计算                 |
   
    public static func isSpecialExcelErrorValue(cellValue:String) -> Bool {
        guard !cellValue.isEmpty else {
            return false;
        }
        // Define Excel error codes
        let errorCodes = [
            "#DIV/0!",
            "#N/A",
            "#VALUE!",
            "#REF!",
            "#NAME?",
            "#NUM!",
            "#NULL!",
            "#SPILL!",
            "#CALC!"
        ]
        return errorCodes.contains(cellValue.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
