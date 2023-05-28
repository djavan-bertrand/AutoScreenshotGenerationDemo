//
//  Copyright © 2019 Tag Heuer Connected. All rights reserved.
//

import Foundation

/// Access to the navigation subclasses
enum UINavigation {
    static let common = CommonNavigation.self
    static let tabBar = TabBarNavigation.self
    static let menu = MenuNavigation.self
    static let favorites = FavoritesNavigation.self
    static let rewards = RewardsNavigation.self
    static let recipes = RecipesNavigation.self
}
