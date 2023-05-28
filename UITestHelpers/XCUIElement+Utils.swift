//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import XCTest

extension XCUIElement {
    func isWithin(_ element: XCUIElement) -> Bool {
        guard exists && !frame.isEmpty && isHittable else {
            return false
        }
        return element.frame.insetBy(dx: -1, dy: -1).contains(frame)
    }

    func swipeUpWithoutVelocity() {
        swipeWithoutVelocity(from: CGVector(dx: 0.5, dy: 0.90), to: CGVector(dx: 0.5, dy: 0.05))
    }

    func swipeDownWithoutVelocity() {
        swipeWithoutVelocity(from: CGVector(dx: 0.5, dy: 0.05), to: CGVector(dx: 0.5, dy: 0.90))
    }

    private func swipeWithoutVelocity(from fromVector: CGVector, to toVector: CGVector) {
        let fromPoint = coordinate(withNormalizedOffset: fromVector)
        let toPoint = coordinate(withNormalizedOffset: toVector)
        fromPoint.press(forDuration: 0, thenDragTo: toPoint)
    }

    /// Scroll down a tableview to its bottom
    ///
    /// - Precondition: this UIElement is a table view
    /// - Parameters:
    ///   - maxTry: max scroll down attempts. Default is 10.
    ///   - iterationBlock: block called at each scroll down with the index of the iteration passed in parameter.
    ///     Default is nil.
    func tableViewScrollToBottom(maxTry: Int = 10,
                                 from fromVector: CGVector = CGVector(dx: 0.5, dy: 0.90),
                                 to toVector: CGVector = CGVector(dx: 0.5, dy: 0.05),
                                 iterationBlock: ((Int) -> Void)? = nil) {
        let cellCount = children(matching: .cell).count
        // avoid infinite loop by restricting to `maxTry`
        for iteration in 0..<maxTry {
            iterationBlock?(iteration)

            // if we are at the bottom, stop the loop
            if cells.element(boundBy: cellCount - 1).isWithin(self) {
                break
            }
            swipeWithoutVelocity(from: fromVector, to: toVector)
        }
    }

    /// Scroll down a scroll view to a given element
    ///
    /// - Precondition: this UIElement is a scroll view
    /// - Parameters:
    ///   - element: the element to display
    ///   - maxTry: max scroll down attempts. Default is 10.
    ///   - fromVector: from point
    ///   - toVector: to point
    ///   - iterationBlock: block called at each scroll down with the index of the iteration passed in parameter.
    ///     Default is nil.
    func scrollViewScrollDown(to element: XCUIElement,
                              maxTry: Int = 10,
                              from fromVector: CGVector = CGVector(dx: 0.5, dy: 0.90),
                              to toVector: CGVector = CGVector(dx: 0.5, dy: 0.05),
                              iterationBlock: ((Int) -> Void)? = nil) {
        // avoid infinite loop by restricting to `maxTry`
        for iteration in 0..<maxTry {
            iterationBlock?(iteration)

            // if we are at the bottom, stop the loop
            if element.isWithin(self) {
                break
            }
            swipeWithoutVelocity(from: fromVector, to: toVector)
        }
    }

    /// Select a picker value based on its index
    ///
    /// - Precondition: this UIElement is a picker wheel
    /// - Parameter index: the picker index to scroll to
    func setPickerValue(index: Int) {
        // go to the first element
        swipeDown()
        // then click below until the correct element is selected
        for _ in 0..<index {
            let topView = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.6))
            topView.tap()
            usleep(5000) // enough time for the picker to be selected
        }
    }

    /// Type a text and clear any existing text before
    ///
    /// - Precondition: this UIElement should responds to `typeText(_)`
    func clearAndTypeText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
