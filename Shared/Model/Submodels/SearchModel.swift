//
//  SearchModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 26/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation

class SearchModel {
    func searchSuggestions(forSearchQuery searchString: String) -> [Ingredient] {
        Ingredient.all.filter {
            $0.name.localizedCaseInsensitiveContains(searchString) &&
            $0.name.localizedCaseInsensitiveCompare(searchString) != .orderedSame
        }
    }
}
