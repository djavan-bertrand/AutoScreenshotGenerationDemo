//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//
import Foundation
import ANSITerminal

/// Interactive picker of the simulators configurations
class SimulatorConfigPicker {
    /// Asks the user for configurations
    /// - Returns: a list of configurations
    func askForConfigs() -> [SimulatorConfig] {
        var configs = [SimulatorConfig]()

        moveLineDown()
        repeat {
            configs.append(pickAConfig())
            displayRecap(configs: configs)
        } while askToContinue()

        writeLine("If you want to use the same config next time, run the script using the declarative mode:".bold)
        print("    swift run generateScreenshots d \(configs.commandLine)".bold)

        return configs
    }

    private func displayRecap(configs: [SimulatorConfig]) {
        if !configs.isEmpty {
            writeLine("Your saved configs:")
            for config in configs {
                writeLine("\("●".lightGreen) \(config.description)")
            }
        }
    }

    private func pickAConfig() -> SimulatorConfig {
        let model = askForModel()
        let os = askForOS()
        let appearance = askForAppearance()
        let contentSize = askForContentSize()
        return SimulatorConfig(model: model, os: os, appearance: appearance, contentSize: contentSize)
    }

    private func askToContinue() -> Bool {
        writeLine("\("◆".foreColor(81).bold) Do you want to select an additional config?")
        writeLine("\("|".foreColor(81)) \("0".bold) Yes")
        writeLine("\("|".foreColor(81)) \("1".bold) No")

        let choice = listenToInput()
        switch choice {
        case 0:
            return true
        case 1:
            return false
        default:
            writeLine("I can't understand your choice, please type again.")
            return askToContinue()
        }
    }

    private func askForModel() -> SimulatorConfig.Model {
        writeLine("\("◆".foreColor(81).bold) Pick a model:")
        SimulatorConfig.Model.allCases.enumerated().forEach {
            writeLine("\("│".foreColor(81)) \("\($0.offset)".bold): \($0.element)")
        }
        let choice = listenToInput()
        if choice >= 0 && choice < SimulatorConfig.Model.allCases.count {
            let model = SimulatorConfig.Model.allCases[choice]
            writeLine("You picked \(model)")
            return model
        } else {
            writeLine("I can't understand your choice, please type again.")
            return askForModel()
        }
    }

    private func askForOS() -> SimulatorConfig.OS {
        writeLine("\("◆".foreColor(81).bold) Pick an OS:")
        SimulatorConfig.OS.allCases.enumerated().forEach {
            writeLine("\("│".foreColor(81)) \("\($0.offset)".bold): \($0.element)")
        }
        let choice = listenToInput()
        if choice >= 0 && choice < SimulatorConfig.OS.allCases.count {
            let os = SimulatorConfig.OS.allCases[choice]
            writeLine("You picked \(os)")
            return os
        } else {
            writeLine("I can't understand your choice, please type again.")
            return askForOS()
        }
    }

    private func askForAppearance() -> SimulatorConfig.Appearance {
        writeLine("\("◆".foreColor(81).bold) Pick an appearance:")
        SimulatorConfig.Appearance.allCases.enumerated().forEach {
            writeLine("\("│".foreColor(81)) \("\($0.offset)".bold): \($0.element)")
        }
        let choice = listenToInput()
        if choice >= 0 && choice < SimulatorConfig.Appearance.allCases.count {
            let appearance = SimulatorConfig.Appearance.allCases[choice]
            writeLine("You picked \(appearance)")
            return appearance
        } else {
            writeLine("I can't understand your choice, please type again.")
            return askForAppearance()
        }
    }

    private func askForContentSize() -> SimulatorConfig.ContentSize {
        writeLine("\("◆".foreColor(81).bold) Pick a content size:")
        SimulatorConfig.ContentSize.allCases.enumerated().forEach {
            writeLine("\("│".foreColor(81)) \("\($0.offset)".bold): \($0.element)")
        }
        let choice = listenToInput()
        if choice >= 0 && choice < SimulatorConfig.ContentSize.allCases.count {
            let contentSize = SimulatorConfig.ContentSize.allCases[choice]
            writeLine("You picked \(contentSize)")
            return contentSize
        } else {
            writeLine("I can't understand your choice, please type again.")
            return askForContentSize()
        }
    }

    // Helper method
    private func writeLine(_ text: String) {
        write(text)
        write("\n")
    }

    private func listenToInput() -> Int {
        var inputs = [Character]()
        while true {
            // 2
            clearBuffer()

            // 3
            if keyPressed() {
                // 4
                let char = readChar()
                if char == NonPrintableChar.enter.char() {
                    write("\n")
                    var multiplier = 1
                    var value = 0
                    for input in inputs.reversed() {
                        guard let intInput = input.wholeNumberValue else { return -1 }
                        value += (intInput * multiplier)
                        multiplier *= 10
                    }
                    return value
                } else {
                    write(String(char))
                    inputs.append(char)
                }
            }
        }
    }
}

extension SimulatorConfig: CustomStringConvertible {
    var description: String {
        "\(model), \(os), \(appearance), \(contentSize)"
    }
}
