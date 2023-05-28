//
//  Created by Djavan BERTRAND.
//  Copyright © 2023 Djavan BERTRAND.
//

import XCTest
import Foundation

enum RecipeAction {
    static func buyRecipes() {
        let purchaseButtons = testedApp.buttons.matching(identifier: "purchaseButton")
        // weird case where there are two purchaseButtons and tapping the first one does not do anything
        // so we need to tap the last one
        purchaseButtons.element(boundBy: purchaseButtons.count - 1).tap()
    }
}
