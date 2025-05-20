//
//  LocalizableMerge.swift
//  AnyTest
//
//  Created by PandaEye on 2022/4/19.
//

public struct CombinedLocalizableString: Codable {

    public let description: String?
    public let key: String
    public let values: [String: String]
}
