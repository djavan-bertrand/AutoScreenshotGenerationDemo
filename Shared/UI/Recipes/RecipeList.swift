/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A list of unlocked smoothies' recipes, and a call to action to purchase all recipes.
*/

import SwiftUI
import StoreKit

struct RecipeList: View {
    private let searchModel = model.searchModel
    private let favModel = model.favoriteSmoothiesModel
    private let storeModel = model.storeModel

    @State var allRecipesUnlocked = false
    @State var unlockAllRecipesProduct: DisplayProduct?
    @State var searchString = ""
    
    var smoothies: [Smoothie] {
        Smoothie.all(includingPaid: allRecipesUnlocked)
            .filter { $0.matches(searchString) }
            .sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
    }
    
    var body: some View {
        List {
            #if os(iOS)
            if !allRecipesUnlocked {
                Section {
                    unlockButton
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(EmptyView())
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                }
                .listSectionSeparator(.hidden)
            }
            #endif
            ForEach(smoothies) { smoothie in
                NavigationLink(destination: RecipeView(smoothie: smoothie)) {
                    SmoothieRow(smoothie: smoothie)
                        .padding(.vertical, 5)
                }
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #elseif os(macOS)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !allRecipesUnlocked {
                unlockButton
                    .padding(8)
            }
        }
        #endif
        .navigationTitle(Text("Recipes", comment: "Title of the 'recipes' app section showing the list of smoothie recipes."))
        .animation(.spring(response: 1, dampingFraction: 1), value: allRecipesUnlocked)
        .accessibilityRotor("Favorite Smoothies", entries: smoothies.filter { favModel.isFavorite(smoothie: $0) }, entryLabel: \.title)
        .accessibilityRotor("Smoothies", entries: smoothies, entryLabel: \.title)
        .searchable(text: $searchString) {
            ForEach(searchModel.searchSuggestions(forSearchQuery: searchString)) { suggestion in
                Text(suggestion.name).searchCompletion(suggestion.name)
            }
        }
        .onReceive(storeModel.allRecipesUnlocked) {
            allRecipesUnlocked = $0
        }
        .onReceive(storeModel.unlockAllRecipesProduct) {
            unlockAllRecipesProduct = $0
        }
    }
    
    @ViewBuilder
    var unlockButton: some View {
        Group {
            if let product = unlockAllRecipesProduct {
                RecipeUnlockButton(
                    product: product,
                    purchaseAction: { storeModel.purchase(product: product) }
                )
            } else {
                RecipeUnlockButton(
                    product: DisplayProduct(
                        title: "Unlock All Recipes",
                        description: "Loading…",
                        availability: .unavailable
                    ),
                    purchaseAction: {}
                )
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                RecipeList()
            }
        }
    }
}
