/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The favorites tab or content list that includes smoothies marked as favorites.
*/

import SwiftUI

struct FavoriteSmoothies: View {
    @State var favoriteSmoothieIds: Set<String> = []

    var body: some View {
        SmoothieList(listKind: .favorites)
            .overlay {
                if favoriteSmoothieIds.isEmpty {
                    Text("Add some smoothies to your favorites!",
                         comment: "Placeholder text shown in list of smoothies when no favorite smoothies have been added yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background()
                        .ignoresSafeArea()
                }
            }
            .navigationTitle(Text("Favorites", comment: "Title of the 'favorites' app section showing the list of favorite smoothies"))
            .onReceive(model.favoriteSmoothiesModel.favoriteSmoothieIds) {
                favoriteSmoothieIds = $0
            }

    }
}

struct FavoriteSmoothies_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteSmoothies()
    }
}
