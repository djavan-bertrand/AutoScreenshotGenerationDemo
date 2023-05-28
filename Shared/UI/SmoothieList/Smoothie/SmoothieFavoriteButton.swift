/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button to favorite a smoothie, can be placed in a toolbar.
*/

import SwiftUI

struct SmoothieFavoriteButton: View {
    let smoothie: Smoothie
    @State var isFavorite = false
    private let favoriteSmoothiesModel = model.favoriteSmoothiesModel
    
    var body: some View {
        Button(action: toggleFavorite) {
            if isFavorite {
                Label {
                    Text("Remove from Favorites", comment: "Toolbar button/menu item to remove a smoothie from favorites")
                } icon: {
                    Image(systemName: "heart.fill")
                }
            } else {
                Label {
                    Text("Add to Favorites", comment: "Toolbar button/menu item to add a smoothie to favorites")
                } icon: {
                    Image(systemName: "heart")
                }

            }
        }
        .accessibility(identifier: "smoothieFavoriteButton")
        .onReceive(favoriteSmoothiesModel.favoriteSmoothieIds) { _ in
            isFavorite = favoriteSmoothiesModel.isFavorite(smoothie: smoothie)
        }
    }
    
    func toggleFavorite() {
        favoriteSmoothiesModel.toggleFavorite(smoothieId: smoothie.id)
    }
}

struct SmoothieFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieFavoriteButton(smoothie: .berryBlue)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
