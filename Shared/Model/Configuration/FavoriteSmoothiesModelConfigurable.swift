//
//  FavoriteSmoothiesModelConfigurable.swift
//  Fruta
//
//  Created by Djavan Bertrand on 16/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine

class FavoriteSmoothiesModelConfigurable: FavoriteSmoothiesModel {
    private(set) var favoriteSmoothieIds = CurrentValueSubject<Set<String>, Never>([])

    init() { }

    func toggleFavorite(smoothieId: Smoothie.ID) {
        var currentFavs = favoriteSmoothieIds.value
        if currentFavs.contains(smoothieId) {
            currentFavs.remove(smoothieId)
        } else {
            currentFavs.insert(smoothieId)
        }
        favoriteSmoothieIds.send(currentFavs)
    }

    func isFavorite(smoothie: Smoothie) -> Bool {
        favoriteSmoothieIds.value.contains(smoothie.id)
    }
}
