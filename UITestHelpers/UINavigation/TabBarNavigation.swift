//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import XCTest
import Foundation

enum TabBarNavigation {

    enum Tab: Int {
        case menu
        case favorites
        case rewards
        case recipes
    }

    static func openTab(_ tab: Tab) {
        testedApp.tabBars.buttons.element(boundBy: tab.rawValue).tap()
    }
}
