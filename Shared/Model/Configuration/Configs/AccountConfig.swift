//
//  AccountConfigs.swift
//  GenerateScreenshots
//
//  Created by Djavan Bertrand on 30/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

/// Configuration of the account
enum AccountConfig: String, Config {
    static var category = ConfigCategory.account

    /// A user is logged in
    case userLogged
    /// A user can redeem a free smoothie (only works in combination of `userLogged`)
    case userCanRedeem
}
