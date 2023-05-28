//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import XCTest
import Foundation

enum MenuNavigation {

    static func openSmoothieDetail(index: Int) {
        var tableView = testedApp.tables.element(boundBy: 0)
        if !tableView.exists {
            // on SwiftUI, List might be backed by a collection view on iOS 16 instead a tableview
            tableView = testedApp.collectionViews.element(boundBy: 0)
        }
        tableView.cells.element(boundBy: index).tap()
    }
}
