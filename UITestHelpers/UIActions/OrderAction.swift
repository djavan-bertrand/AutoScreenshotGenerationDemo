//
//  Created by Djavan BERTRAND.
//  Copyright © 2023 Djavan BERTRAND.
//

import XCTest
import Foundation

enum OrderAction {
    static func orderSmoothie() {
        testedApp.buttons["payButton"].tap()
    }

    static func redeemSmoothie() {
        testedApp.buttons["redeemButton"].tap()
    }
}
