//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import XCTest
import Foundation

enum FavoritesNavigation {
    static func openSmoothieDetail(index: Int) {
        testedApp.tables.cells.element(boundBy: index).tap()
    }
}
