//
//  FavoriteSmoothiesModelDefault.swift
//  Fruta
//
//  Created by Djavan Bertrand on 26/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine

protocol FavoriteSmoothiesModel {
    var favoriteSmoothieIds: CurrentValueSubject<Set<String>, Never> { get }

    func toggleFavorite(smoothieId: Smoothie.ID)

    func isFavorite(smoothie: Smoothie) -> Bool
}

class FavoriteSmoothiesModelDefault: FavoriteSmoothiesModel {
    private(set) var favoriteSmoothieIds = CurrentValueSubject<Set<String>, Never>([])

    private let userDefaults = UserDefaults.standard
    private let favsKey = "favoriteSmoothies"

    init() {
        if let favs = userDefaults.array(forKey: favsKey) as? [String] {
            favoriteSmoothieIds.send(Set(favs))
        }
    }

    func toggleFavorite(smoothieId: Smoothie.ID) {
        var currentFavs = favoriteSmoothieIds.value
        if currentFavs.contains(smoothieId) {
            currentFavs.remove(smoothieId)
        } else {
            currentFavs.insert(smoothieId)
        }
        userDefaults.set(Array(currentFavs), forKey: favsKey)
        favoriteSmoothieIds.send(currentFavs)
    }

    func isFavorite(smoothie: Smoothie) -> Bool {
        favoriteSmoothieIds.value.contains(smoothie.id)
    }
}
