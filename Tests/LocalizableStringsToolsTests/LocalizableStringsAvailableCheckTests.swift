//
//  File.swift
//  LocalizableStringsTools
//
//  Created by PandaEye on 2025/6/4.
//

import Testing
@testable import LocalizableStringsTools

/// 测试所有有效的 Excel 错误码
@Test func validExcelErrorCodes() async throws {
    let codes = [
        "#DIV/0!", "#N/A", "#VALUE!", "#REF!", "#NAME?", "#NUM!", "#NULL!", "#SPILL!", "#CALC!"
    ]
    for code in codes {
        #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: code) == true)
    }
}

/// 测试带有前后空白字符的有效 Excel 错误码
@Test func validExcelErrorCodesWithWhitespace() async throws {
    #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: "  #REF! ") == true)
    #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: "\t#N/A\n") == true)
}

/// 测试无效的错误码和普通字符串
@Test func invalidExcelErrorCodes() async throws {
    let invalids = [
        "", "N/A", "#DIV0!", "#REF", "error", "#VALUE", "#NAME", "#NUM", "#NULL", "#SPILL", "#CALC", " #DIV/0!x"
    ]
    for value in invalids {
        #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: value) == false)
    }
}
