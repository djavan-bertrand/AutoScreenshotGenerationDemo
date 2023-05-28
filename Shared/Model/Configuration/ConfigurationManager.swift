//
//  ConfirgurationManager.swift
//  Fruta
//
//  Created by Djavan Bertrand on 16/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

public class ConfigurationManager {

    static let instance = ConfigurationManager()

    /// Launch argument that will trigger a configuration setup if passed as a launch argument
    public static let launchArgument = "RunForConfiguration"

    let commonConfigs: Set<CommonConfig>
    let accountConfigs: Set<AccountConfig>
    let storeConfigs: Set<StoreConfig>

    private init() {
        let env = ProcessInfo.processInfo.environment
        commonConfigs = Set(from: env)
        accountConfigs = Set(from: env)
        storeConfigs = Set(from: env)
    }

}

/// Categories of configuration available
enum ConfigCategory: String {
    case common
    case account
    case store
}


/// An object that represents a Configuration
protocol Config {
    /// The category related to this configuration
    static var category: ConfigCategory { get }
    /// the raw value
    var rawValue: String { get }
    /// the config key that will be passed as launch argument
    var configKey: String { get }
}

extension Config {
    var configKey: String {
        return "\(Self.category.rawValue)\(CategoryAndKey.separator)\(rawValue)"
    }
}

/// Extension of a `Set<Configuration>` that adds a constructor from a dictionary
extension Set where Element: RawRepresentable, Element.RawValue == String, Element: Config {
    init(from dictionary: [String: String]) {
        var configs = Set<Element>()
        for configKey in dictionary.keys {
            print(configKey)
            if let categoryAndKey = CategoryAndKey(from: configKey), categoryAndKey.category == Element.category {
                configs.insert(Element(rawValue: categoryAndKey.key)!)
            }
        }

        self = configs
    }
}

/// Extension of a `[Configuration]` that adds an export to a dictionary
extension Array where Element == Config {
    func toDictionary() -> [String: String] {
        return Dictionary(uniqueKeysWithValues: map { ($0.configKey, "") })
    }
}

private struct CategoryAndKey {
    fileprivate static let separator = Character("-")

    fileprivate let category: ConfigCategory
    fileprivate let key: String

    init?(from configKey: String) {
        let splittedKey = configKey.split(separator: Self.separator)
        guard splittedKey.count == 2,
            let category = ConfigCategory(rawValue: String(splittedKey[0])) else {
                return nil
        }

        self.category = category
        self.key = String(splittedKey[1])
    }
}
