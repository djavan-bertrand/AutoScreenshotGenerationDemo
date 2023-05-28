/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A reusable view that can display a list of arbritary smoothies.
*/

import SwiftUI

struct SmoothieList: View {
    @ObservedObject private var viewModel: SmoothieListViewModel

    init(listKind: SmoothieListViewModel.ListKind) {
        viewModel = SmoothieListViewModel(listKind: listKind)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.listedSmoothies) { smoothie in
                    NavigationLink(destination: SmoothieView(smoothie: smoothie)) {
                        SmoothieRow(smoothie: smoothie)
                    }
                    .swipeActions {
                        Button {
                            withAnimation {
                                viewModel.toggleFavorite(smoothieId: smoothie.id)
                            }
                        } label: {
                            Label {
                                Text("Favorite", comment: "Swipe action button in smoothie list")
                            } icon: {
                                Image(systemName: "heart")
                            }
                        }
                        .tint(.accentColor)
                    }
                }
            }
            .searchable(text: $viewModel.searchString) {
                ForEach(viewModel.searchSuggestions) { suggestion in
                    Text(suggestion.name).searchCompletion(suggestion.name)
                }
            }
        }
    }
}

struct SmoothieList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                SmoothieList(listKind: .all)
                    .navigationTitle(Text("Smoothies", comment: "Navigation title for the full list of smoothies"))
            }
            .preferredColorScheme(scheme)
        }
    }
}
