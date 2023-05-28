/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The single entry point for the Fruta app on iOS and macOS.
*/

import SwiftUI
/// - Tag: SingleAppDefinitionTag
@main
struct FrutaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
            SmoothieCommands()
        }
    }
}

let model = Model()
