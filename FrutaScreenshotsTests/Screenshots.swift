//
//  Screenshots.swift
//  GenerateScreenshots
//
//  Created by Djavan Bertrand on 28/12/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import XCTest

/// A screenshot type
enum Screenshot: Int {
    case menu
    case detail
    case detailFavorite
    case detailRedeemable
    case preparingPurchaseWhenLoggedOut
    case purchaseReadyWhenLoggedOut
    case preparingPurchaseWhenLoggedIn
    case purchaseReadyWhenLoggedIn
    case preparingPurchaseWhenRedeem
    case purchaseReadyWhenRedeem
    case favorites
    case rewardsLoggedOut
    case rewardsEmpty
    case rewardsNotFull
    case rewardsFull
    case recipesNotBoughtProductNotReceived
    case recipesNotBought
    case recipesBought
    case recipeDetail
}
