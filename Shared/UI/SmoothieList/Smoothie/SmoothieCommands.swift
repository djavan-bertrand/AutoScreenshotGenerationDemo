/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom commands that you add to the application's Main Menu.
*/

import SwiftUI

struct SmoothieCommands: Commands {
    var body: some Commands {
        CommandMenu(Text("Smoothie", comment: "Menu title for smoothie-related actions")) {
            SmoothieFavoriteButton(smoothie: .thatsASmore) // TODO Djavan
                .keyboardShortcut("+", modifiers: [.option, .command])
        }
    }
}
