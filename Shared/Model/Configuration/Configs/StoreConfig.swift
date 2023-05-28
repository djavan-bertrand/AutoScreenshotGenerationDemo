//
//  AccountConfigs.swift
//  GenerateScreenshots
//
//  Created by Djavan Bertrand on 30/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

/// Configuration of the account
enum StoreConfig: String, Config {
    static var category = ConfigCategory.store

    /// The all recipe product has been purchased
    case allRecipeProductPurchased
    /// The fetch products request has succeeded
    case receivedProducts
}
