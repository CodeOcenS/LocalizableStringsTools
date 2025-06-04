//
//  File.swift
//  LocalizableStringsTools
//
//  Created by PandaEye on 2025/6/4.
//


import Testing
@testable import LocalizableStringsTools

/// Test all valid Excel error codes
@Test func validExcelErrorCodes() async throws {
    let codes = [
        "#DIV/0!", "#N/A", "#VALUE!", "#REF!", "#NAME?", "#NUM!", "#NULL!", "#SPILL!", "#CALC!"
    ]
    for code in codes {
        #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: code) == true)
    }
}

/// Test valid codes with leading/trailing whitespace
@Test func validExcelErrorCodesWithWhitespace() async throws {
    #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: "  #REF! ") == true)
    #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: "\t#N/A\n") == true)
}

/// Test invalid codes and normal strings
@Test func invalidExcelErrorCodes() async throws {
    let invalids = [
        "", "N/A", "#DIV0!", "#REF", "error", "#VALUE", "#NAME", "#NUM", "#NULL", "#SPILL", "#CALC", " #DIV/0!x"
    ]
    for value in invalids {
        #expect(LocalizableStringsAvailableCheck.isSpecialExcelErrorValue(cellValue: value) == false)
    }
}
