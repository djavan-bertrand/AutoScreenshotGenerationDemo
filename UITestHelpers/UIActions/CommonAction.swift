//
//  Created by Djavan BERTRAND.
//  Copyright © 2023 Djavan BERTRAND.
//

import XCTest
import Foundation

enum CommonAction {
    static func toggleFavorite() {
        testedApp.buttons["smoothieFavoriteButton"].tap()
    }
}
