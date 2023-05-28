//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//

import Foundation

/// Parser of the arguments passed to the declarative option
class DeclarativeConfigParser {
    /// Transforms a list of strings into a list of simulators configurations
    /// - Parameter rawConfigs: the list of configuration as string
    /// - Returns: the list of configurations
    func parse(rawConfigs: [String]) -> [SimulatorConfig] {
        var configs = [SimulatorConfig]()
        for rawConfig in rawConfigs {
            let rawTraits = rawConfig.split(separator: ",")
            var traits = [String: String]()
            for rawTrait in rawTraits {
                let keyAndValue = rawTrait.split(separator: ":")
                guard keyAndValue.count == 2 else {
                    print("Ignoring \(rawTrait) because it does not contain the correct key or value")
                    continue
                }
                traits[String(keyAndValue[0])] = String(keyAndValue[1])
            }
            guard let model = SimulatorConfig.Model(traits[SimulatorConfig.Model.argName]) else {
                print("Error: the model is mandatory".foreColor(9))
                exit(-1)
            }
            configs.append(SimulatorConfig(
                model: model,
                os: SimulatorConfig.OS(traits[SimulatorConfig.OS.argName]) ?? .defaultValue,
                appearance: SimulatorConfig.Appearance(traits[SimulatorConfig.Appearance.argName]) ?? .defaultValue,
                contentSize: SimulatorConfig.ContentSize(traits[SimulatorConfig.ContentSize.argName]) ?? .defaultValue))
        }

        return configs
    }
}

extension SimulatorConfig.Model {
    static let argName = "m"
    var argValue: String {
        switch self {
        case .iPhone14:         return "14"
        case .iPhone8:          return "8"
        case .iPhoneX:          return "X"
        case .iPhoneSE2:        return "SE2"
        case .iPhone14Pro:      return "14Pro"
        case .iPhone14ProMax:   return "14ProMax"
        }
    }

    init?(_ argValue: String?) {
        guard let argValue else { return nil }
        for value in Self.allCases {
            if value.argValue == argValue {
                self = value
                return
            }
        }
        return nil
    }
}

extension SimulatorConfig.OS {
    static let argName = "o"
    var argValue: String {
        switch self {
        case .iOS14: return "14"
        case .iOS15: return "15"
        case .iOS16:  return "16"
        }
    }

    init?(_ argValue: String?) {
        guard let argValue else { return nil }
        for value in Self.allCases {
            if value.argValue == argValue {
                self = value
                return
            }
        }
        return nil
    }
}

extension SimulatorConfig.Appearance {
    static let argName = "a"
    var argValue: String {
        switch self {
        case .dark:     return "dark"
        case .light:    return "light"
        }
    }

    init?(_ argValue: String?) {
        guard let argValue else { return nil }
        for value in Self.allCases {
            if value.argValue == argValue {
                self = value
                return
            }
        }
        return nil
    }
}

extension SimulatorConfig.ContentSize {
    static let argName = "c"
    var argValue: String {
        switch self {
        case .extraSmall:       return "XS"
        case .small:            return "S"
        case .medium:           return "M"
        case .large:            return "L"
        case .extraLarge:       return "XL"
        case .extraExtraLarge:  return "XXL"
        }
    }

    init?(_ argValue: String?) {
        guard let argValue else { return nil }
        for value in Self.allCases {
            if value.argValue == argValue {
                self = value
                return
            }
        }
        return nil
    }
}

extension Array where Element == SimulatorConfig {
    var commandLine: String {
        var configStrArray = [String]()
        for config in self {
            var traitStrArray = [String]()
            traitStrArray.append("\(SimulatorConfig.Model.argName):\(config.model.argValue)")
            if config.os != SimulatorConfig.OS.defaultValue {
                traitStrArray.append("\(SimulatorConfig.OS.argName):\(config.os.argValue)")
            }
            if config.appearance != SimulatorConfig.Appearance.defaultValue {
                traitStrArray.append("\(SimulatorConfig.Appearance.argName):\(config.appearance.argValue)")
            }
            if config.contentSize != SimulatorConfig.ContentSize.defaultValue {
                traitStrArray.append("\(SimulatorConfig.ContentSize.argName):\(config.contentSize.argValue)")
            }
            configStrArray.append(traitStrArray.joined(separator: ","))
        }
        return configStrArray.joined(separator: " ")
    }
}
