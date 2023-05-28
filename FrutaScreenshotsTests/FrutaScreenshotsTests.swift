//
//  Created by Djavan BERTRAND on 28/05/2023.
//  Copyright © 2023 Djavan BERTRAND. All rights reserved.
//

import XCTest

final class FrutaScreenshotsTests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        testedApp = app
        app.launchArguments = [ConfigurationManager.launchArgument]
    }

    func testMainUserPath() throws {
        // launch the app with a user logged in
        app.launchEnvironment = [
            AccountConfig.userLogged,
            StoreConfig.receivedProducts,
        ].toDictionary()
        app.launch()

        UINavigation.tabBar.openTab(.rewards)
        takeScreenshot(.rewardsEmpty)

        UINavigation.tabBar.openTab(.menu)

        takeTableViewScrollingScreenshot(.menu)

        UINavigation.menu.openSmoothieDetail(index: 2)
        takeScreenshot(.detail)

        UIAction.common.toggleFavorite()
        takeScreenshot(.detailFavorite)

        UIAction.order.orderSmoothie()
        takeScreenshot(.preparingPurchaseWhenLoggedIn)
        takeScreenshot(.purchaseReadyWhenLoggedIn, waitForExistence: app.staticTexts["orderReadyCard"].firstMatch)

        UINavigation.common.done()
        UINavigation.common.back()
        UINavigation.tabBar.openTab(.favorites)
        takeScreenshot(.favorites)

        UINavigation.tabBar.openTab(.rewards)
        takeScreenshot(.rewardsNotFull)

        UINavigation.tabBar.openTab(.recipes)
        takeTableViewScrollingScreenshot(.recipesNotBought)

        UIAction.recipe.buyRecipes()
        takeTableViewScrollingScreenshot(.recipesBought)

        UINavigation.recipes.openRecipeDetail(index: 0)
        takeScrollViewScrollingScreenshot(.recipeDetail, to: app.switches["lastElement"])

    }

    func testLoggedOutAndProductNotReceived() throws {
        app.launchEnvironment = [].toDictionary()
        app.launch()

        UINavigation.menu.openSmoothieDetail(index: 1)
        UIAction.order.orderSmoothie()
        takeScreenshot(.preparingPurchaseWhenLoggedOut)
        takeScreenshot(.purchaseReadyWhenLoggedOut, waitForExistence: app.staticTexts["orderReadyCard"].firstMatch)

        UINavigation.common.done()
        UINavigation.common.back()
        UINavigation.tabBar.openTab(.rewards)
        takeScreenshot(.rewardsLoggedOut)

        UINavigation.tabBar.openTab(.recipes)
        takeTableViewScrollingScreenshot(.recipesNotBoughtProductNotReceived)
    }

    func testRedeem() throws {
        // launch the app with a user logged in
        app.launchEnvironment = [
            AccountConfig.userLogged,
            AccountConfig.userCanRedeem
        ].toDictionary()
        app.launch()

        UINavigation.tabBar.openTab(.rewards)
        takeScreenshot(.rewardsFull)

        UINavigation.tabBar.openTab(.menu)
        UINavigation.menu.openSmoothieDetail(index: 2)
        takeScreenshot(.detailRedeemable)

        UIAction.order.redeemSmoothie()
        takeScreenshot(.preparingPurchaseWhenRedeem)
        takeScreenshot(.purchaseReadyWhenRedeem, waitForExistence: app.staticTexts["orderReadyCard"].firstMatch)
    }
}
