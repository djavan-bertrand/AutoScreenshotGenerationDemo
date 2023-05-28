/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The single entry point for the Fruta app on iOS and macOS.
*/

import SwiftUI
/// - Tag: SingleAppDefinitionTag
@main
struct FrutaApp: App {
    init() {
        if isRunningForConfiguration {
            UIView.setAnimationsEnabled(false)
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.layer.speed = 100
        }
    }
    
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

let model = Model(forConfiguration: isRunningForConfiguration)
/// Detect if the app is running for configuration
var isRunningForConfiguration: Bool = {
    #if DEBUG
    return CommandLine.arguments.contains(ConfigurationManager.launchArgument)
    #else
    return false
    #endif
}()
