# LocalizableStringsTools

这个 Swift 库提供了一系列工具方法，用于处理 iOS/macOS 应用程序中的多语言本地化字符串文件（.strings 文件）。

## 功能特点

### 字符串文件解析 (StringsFileParse)

- 从 .strings 文件中读取并解析 key、value 和注释
- 支持通过正则表达式解析 Localizable.strings 文件
- 提供数据模型用于表示本地化字符串及其属性

### 多语言文件合并

- 支持合并多个不同语言的 .strings 文件
- 以基准文件为基础，合并其他语言文件中的相同键值
- 生成包含多语言值的合并结果

### 字符串插入工具

- 提供查找插入位置的工具方法
- 支持在现有 .strings 文件中插入新的本地化字符串
- 处理各种插入场景（如注释、空行等）

## 使用要求

- Swift 6.0+
- macOS 13.0+ / iOS 16.0+（部分功能）

## 安装方法

### Swift Package Manager

在你的 `Package.swift` 文件中添加以下依赖：

```swift
dependencies: [
    .package(url: "YOUR_REPOSITORY_URL", from: "1.0.0")
]
```

## 使用示例

### 解析 .strings 文件

```swift
import LocalizableStringsTools

// 解析字符串内容
let content = "/* Comment */\n\"key\" = \"value\";"
let result = LocalizableStringsParser.parse(string: content, locale: "en")

// 访问解析结果
for item in result.localizableStrings {
    print("Key: \(item.key)")
    print("Value: \(item.value)")
    if let description = item.description {
        print("Description: \(description)")
    }
}
```

### 合并多语言文件

```swift
import LocalizableStringsTools

// 假设已经解析了英文和中文的 .strings 文件
let enFile: LocalizableStringsFile = /* 英文文件解析结果 */
let zhFile: LocalizableStringsFile = /* 中文文件解析结果 */

// 以英文文件为基准合并中文文件
let merged = LocalizableStringsFile.merge([zhFile], to: enFile)

// 访问合并结果
for item in merged {
    print("Key: \(item.key)")
    print("English: \(item.values[\"en\"] ?? \"\")")
    print("Chinese: \(item.values[\"zh\"] ?? \"\")")
}
```

### 查找插入位置

```swift
import LocalizableStringsTools

// 查找插入位置
do {
    let content = "/* Comment */\n\"key\" = \"value\";"
    let (insertIndex, hasEmptyLines) = try LocalizableStringsUtils.findInsertIndex(allStrings: content, subStr: "key")
    
    if let index = insertIndex {
        // 在找到的位置插入新内容
        // ...
    }
} catch {
    print("Error: \(error)")
}
```
