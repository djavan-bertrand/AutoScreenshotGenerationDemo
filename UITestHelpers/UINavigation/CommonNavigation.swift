//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import XCTest
import Foundation

enum CommonNavigation {
    /// Goes back
    /// - precondition: The nav bar first element should be the back button
    static func back() {
        testedApp.navigationBars.buttons.element(boundBy: 0).tap()
    }

    /// Presses the done button
    /// - precondition: A button with identifier `doneButton` should be present
    static func done() {
        testedApp.buttons["doneButton"].tap()
    }
}
