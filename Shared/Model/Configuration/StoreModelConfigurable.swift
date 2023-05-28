//
//  StoreModelConfigurable.swift
//  Fruta iOS
//
//  Created by Djavan Bertrand on 28/12/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine
import StoreKit

class StoreModelConfigurable: StoreModel {
    let allRecipesUnlocked = CurrentValueSubject<Bool, Never>(false)
    let unlockAllRecipesProduct = CurrentValueSubject<DisplayProduct?, Never>(nil)

    init() {
        if ConfigurationManager.instance.storeConfigs.contains(.allRecipeProductPurchased) {
            allRecipesUnlocked.send(true)
        }
        if ConfigurationManager.instance.storeConfigs.contains(.receivedProducts) {
            unlockAllRecipesProduct.send(DisplayProduct(
                title: "Unlock All Recipes", description: "Make smoothies at home!",
                availability: .available(displayPrice: "20$")))
        }
    }

    func purchase(product: DisplayProduct) {
        self.allRecipesUnlocked.send(true)
    }
}
