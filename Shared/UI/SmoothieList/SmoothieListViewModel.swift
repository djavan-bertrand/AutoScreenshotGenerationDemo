//
//  SmoothieListViewModel.swift
//  Fruta
//
//  Created by Djavan Bertrand on 16/11/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Combine

class SmoothieListViewModel: ObservableObject {
    enum ListKind {
        case allFree
        case all
        case favorites
    }

    @Published private(set) var listedSmoothies: [Smoothie] = []
    @Published var searchString = "" {
        didSet {
            updateListedSmoothies()
        }
    }
    var searchSuggestions: [Ingredient] {
        searchModel.searchSuggestions(forSearchQuery: searchString)
    }

    private let searchModel = model.searchModel
    private let favsModel = model.favoriteSmoothiesModel
    private var smoothies: [Smoothie]

    private var storage = Set<AnyCancellable>()

    init(listKind: ListKind) {
        switch listKind {
        case .allFree:
            smoothies = Smoothie.all(includingPaid: false)
        case .all:
            smoothies = Smoothie.all(includingPaid: true)
        case .favorites:
            smoothies = []
            model.favoriteSmoothiesModel.favoriteSmoothieIds.sink { [unowned self] favSmoothies in
                self.smoothies = favSmoothies.map { Smoothie(for: $0)! }
                updateListedSmoothies()
            }.store(in: &storage)
        }

        updateListedSmoothies()
    }

    func toggleFavorite(smoothieId: String) {
        favsModel.toggleFavorite(smoothieId: smoothieId)
    }

    private func updateListedSmoothies() {
        listedSmoothies = smoothies
            .filter { $0.matches(searchString) }
            .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
    }
}

