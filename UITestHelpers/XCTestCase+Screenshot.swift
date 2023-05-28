//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func takeScrollViewScrollingScreenshot(_ screenshot: Screenshot, to element: XCUIElement,
                                                   maxTry: Int = 10,
                                                   from fromVector: CGVector = CGVector(dx: 0.5, dy: 0.90),
                                                   to toVector: CGVector = CGVector(dx: 0.5, dy: 0.05)) {
        let scrollView = testedApp.scrollViews.element(boundBy: 0)
        scrollView.scrollViewScrollDown(to: element, maxTry: maxTry, from: fromVector, to: toVector) {
            self.takeScreenshot(screenshot, suffix: "\($0 + 1)")
        }
    }

    func takeTableViewScrollingScreenshot(_ screenshot: Screenshot,
                                                  maxTry: Int = 10,
                                                  from fromVector: CGVector = CGVector(dx: 0.5, dy: 0.90),
                                                  to toVector: CGVector = CGVector(dx: 0.5, dy: 0.05)) {
        var tableView = testedApp.tables.element(boundBy: 0)
        if !tableView.exists {
            // on SwiftUI, List might be backed by a collection view instead
            tableView = testedApp.collectionViews.element(boundBy: 0)
        }
        
        tableView.tableViewScrollToBottom(maxTry: maxTry, from: fromVector, to: toVector) {
            self.takeScreenshot(screenshot, suffix: "\($0 + 1)")
        }
    }

    /// Take a screenshot and add it to the tests attachments
    /// - Parameters:
    ///   - screenshot: the screenshot to take
    func takeScreenshot(_ screenshot: Screenshot) {
        let name = "\(String(format: "%03d", screenshot.rawValue))-\(screenshot)"

        guard let window = testedApp.windows.allElementsBoundByIndex.first(where: { $0.frame.isEmpty == false }) else {
            XCTFail("Couldn't find an element window in XCUIApplication with a non-empty frame.")
            return
        }
        let windowScreenshot = window.screenshot()
        let attachment = XCTAttachment(screenshot: windowScreenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Take a screenshot and add it to the tests attachments
    /// - Parameters:
    ///   - screenshot: the screenshot to take
    ///   - suffix: the suffix that should be appened to the name
    ///   - waitForExistence: element to wait for its existence. If specified, `waitTime` will be used as a timeout
    ///     value
    ///   - waitTime: the time in seconds to wait before taking the screenshot. Default is nil
    func takeScreenshot(_ screenshot: Screenshot, suffix: String? = nil,
                        waitForExistence element: XCUIElement? = nil, waitTime: Double? = nil) {
        if let element = element {
            if !element.waitForExistence(timeout: waitTime ?? 5.0) {
                XCTFail("Tried to wait for \(element) to be existing. Timed out.")
            }
        } else if let waitTime = waitTime {
            usleep(UInt32(waitTime * 1000000))
        }

        let name = "\(String(format: "%03d", screenshot.rawValue))-\(screenshot)\(suffix ?? "")"

        guard let window = testedApp.windows.allElementsBoundByIndex.first(where: { $0.frame.isEmpty == false }) else {
            XCTFail("Couldn't find an element window in XCUIApplication with a non-empty frame.")
            return
        }
        let windowScreenshot = window.screenshot()
        let attachment = XCTAttachment(screenshot: windowScreenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
