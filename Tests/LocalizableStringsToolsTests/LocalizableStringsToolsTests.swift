import Testing
@testable import LocalizableStringsTools
/// 正常数据测试
@Test func normalStrings() async throws {
    // Example input string
    let input = """
        // xxxxxxx
        // 头部注释
        "key1" = "value1";
        "key2" = "value2"; // key2
        "key3" = "value3";  // key3
        /* 多行注释
        "key4" = "value4";  // key4
        */
        "key5" = "value5";  // key5
        """
    
    // Expected output
    let prefix = """
        // xxxxxxx
        // 头部注释
        """
    let mutDes = """
          // key3
        /* 多行注释
        """
    let expectedOutput = [
        LocalizableString(description: prefix, key: "key1", value: "value1"),
        LocalizableString(description: nil, key: "key2", value: "value2"),
        LocalizableString(description: " // key2", key: "key3", value: "value3"),
        LocalizableString(description: mutDes, key: "key4", value: "value4"),  // 注意这种情况目前正则能单独匹配出来，待优化
        LocalizableString(description: "  // key4\n*/", key: "key5", value: "value5")
    ]
    
    // Parse the input string
    let result = LocalizableStringsParser.parse(string: input, locale: "en")
    
    // Check if the result matches the expected output
    #expect(result.localizableStrings.count == expectedOutput.count, "数量应该相等");
    #expect(result.localizableStrings.first?.key == expectedOutput.first?.key && result.localizableStrings.first?.value == expectedOutput.first?.value, "第一个 key 和 value 应该相等")
    #expect(result.localizableStrings == expectedOutput)
}
/// 首行不换行匹配测试
@Test func examp1() async throws {
    // Example input string
    let input = """
        "key1" = "value1";
        "key2" = "value2"; // key2
        "key3" = "value3";  // key3
        """
    // Expected output
    let expectedOutput = [
        LocalizableString(description: nil, key: "key1", value: "value1"),
        LocalizableString(description: nil, key: "key2", value: "value2"),
        LocalizableString(description: " // key2", key: "key3", value: "value3")
    ]
    // Parse the input string
    let result = LocalizableStringsParser.parse(string: input, locale: "en")
    #expect(result.localizableStrings == expectedOutput)
}
///  key 包含\" 匹配
@Test func examp2() async throws {
    // Example input string
    let input = """
        "key1" = "value1";
        "Allow %@ to access your album in \"Settings -> Privacy -> Photos\"" = "Please allow %@ to access your photo in Settings > Privacy > Photos on iPhone.";
        "Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\"" = "Please allow %@ to access your camera in iPhone's Settings > Privacy > Camera";
        "Allow %@ to access your all photos" = "%@ can only access selected photos. Allow access \"All Photos\"";
        """
    // Expected output
    let expectedOutput = [
        LocalizableString(description: nil, key: "key1", value: "value1"),
        LocalizableString(description: nil, key: "Allow %@ to access your album in \"Settings -> Privacy -> Photos\"", value: "Please allow %@ to access your photo in Settings > Privacy > Photos on iPhone."),
        LocalizableString(description: nil, key: "Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\"", value: "Please allow %@ to access your camera in iPhone's Settings > Privacy > Camera"),
        LocalizableString(description: nil, key: "Allow %@ to access your all photos", value: "%@ can only access selected photos. Allow access \"All Photos\"")
    ]
    // Parse the input string
    let result = LocalizableStringsParser.parse(string: input, locale: "en")
    #expect(result.localizableStrings == expectedOutput)
}

/// replaceSpecial方法测试
@Test func testReplaceSpecial() async throws {
    // 测试全角符号替换
    let test1 = LocalizableStringsUtils.replaceSpecial("％＠｛｝")
    #expect(test1 == "%@{}")
    
    // 测试%s替换为%@
    let test2 = LocalizableStringsUtils.replaceSpecial("%s")
    #expect(test2 == "%@")
    
    // 测试引号转义
    let test3 = LocalizableStringsUtils.replaceSpecial("\"value\"")
    #expect(test3 == "\\\"value\\\"")
    
    // 测试混合情况
    let test4 = LocalizableStringsUtils.replaceSpecial("％s\"value\"")
    #expect(test4 == "%@\\\"value\\\"")
}
