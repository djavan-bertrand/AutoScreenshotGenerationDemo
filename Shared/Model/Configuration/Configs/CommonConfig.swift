//
//  AccountConfigs.swift
//  GenerateScreenshots
//
//  Created by Djavan Bertrand on 30/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

/// Common configuration
enum CommonConfig: String, Config {
    static var category = ConfigCategory.common

    /// Force the dark mode
    case forceDarkMode
    /// Force the light mode
    case forceLightMode

}
