//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//

import Foundation
import ANSITerminal
import ArgumentParser

/// Entry point of this package
/// It will parse the arguments provided to compute the correct simulators configurations and generate screenshots on
/// them.
@main
struct ScreenshotsGenerator: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Take screenshots of the app on differents devices and creates an HTML file containing these " +
        "screenshots. You can either configure the simulators to run with text (d option) or interactively (i).",
        subcommands: [Declarative.self, Interactive.self],
        defaultSubcommand: Interactive.self)

    /// Declarative option: the user will pass a string that describes the simulators configurations
    struct Declarative: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "d",
            abstract: "Configure the simulators to run on by using textual declaration.")

        @Argument(help: ArgumentHelp(
            "List of simulator configurations.",
            discussion: "List of simulator configurations.\nEach simulator is defined by a string separated by " +
            "spaces.\nEach of these string contains a list of the different trait of a simulator: its model, OS, " +
            "appearance and content size.\nEach trait is separated by a comma and is composed of a key, the symbol " +
            "`:` and the value. Here the exhaustive description of these traits:\n " +
            "- Model:\n" +
            "    Key is `\(SimulatorConfig.Model.argName)`.\n" +
            "    Values are:\n" +
            "\(SimulatorConfig.Model.allCases.map { "        - \($0.argValue): \($0)" }.joined(separator: "\n"))" +
            "\n\n" +

            "- OS (Optional):\n" +
            "    Key is `\(SimulatorConfig.OS.argName)`.\n" +
            "    Values are:\n" +
            "\(SimulatorConfig.OS.allCases.map { "        - \($0.argValue): \($0)" }.joined(separator: "\n"))" +
            "\n" +
            "        Default value is \(SimulatorConfig.OS.defaultValue)\n\n" +

            "- Appearance (Optional):\n" +
            "    Key is `\(SimulatorConfig.Appearance.argName)`.\n" +
            "    Values are:\n" +
            "\(SimulatorConfig.Appearance.allCases.map { "        - \($0.argValue): \($0)" }.joined(separator: "\n"))" +
            "\n" +
            "        Default value is \(SimulatorConfig.Appearance.defaultValue)\n\n" +

            "- Content Size (Optional):\n" +
            "    Key is `\(SimulatorConfig.ContentSize.argName)`.\n" +
            "    Values are:\n" +
            "\(SimulatorConfig.ContentSize.allCases.map { "        - \($0.argValue): \($0)" }.joined(separator: "\n"))" +
            "\n" +
            "        Default value is \(SimulatorConfig.ContentSize.defaultValue)\n\n" +

            "So calling this with arguments `m:14,o:16 m:16,a:dark,c:XL` will create 2 simulators:\n" +
            "  - an iPhone 14 running iOS 16 with default appearance and default content size\n" +
            "  - an iPhone 16 running default OS with dark appearance and extra large content size.",
            valueName: "configurations"
        ))
        var configurationsStr: [String]

        mutating func run() {
            let configs = DeclarativeConfigParser().parse(rawConfigs: configurationsStr)
            ScreenshotGenerationOrchestrator.generate(configs: configs)
        }
    }

    /// Interactive option: the user will build the list of simulator configs in the terminal using the keyboard
    struct Interactive: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "i",
            abstract: "Configure the simulators to run on interactively.")

        mutating func run() {
            let configs = SimulatorConfigPicker().askForConfigs()
            ScreenshotGenerationOrchestrator.generate(configs: configs)
        }
    }
}
