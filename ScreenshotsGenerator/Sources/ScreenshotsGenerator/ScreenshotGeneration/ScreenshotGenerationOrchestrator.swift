//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//

import Foundation

/// Utility class that will take a list of simulators as input and generates screenshots on them
enum ScreenshotGenerationOrchestrator {

    private static let latestScreenshotsResultsPath = "./latestScreenshotsResults.xcresult"
    private static let screenshotsPageFolder = "./Screenshots/"


    /// Generates screenshots using the given simulators configurations
    /// - Parameter configs: the simulators configurations
    static func generate(configs: [SimulatorConfig]) {
        let startDate = Date()
        print("Deleting xcresult file")
        Command.runAndPrint("rm -rf \(latestScreenshotsResultsPath)")

        print("Disconnect hardware keyboard from iPhone simulators")
        Command.runAndPrint("defaults write com.apple.iphonesimulator ConnectHardwareKeyboard -bool false")

        let (result, simulatorIds) = createSimulators(configs: configs)
        guard result == EXIT_SUCCESS else {
            deleteSimulators(ids: simulatorIds)
            exit(result)
        }
        let simulatorConfigs = Dictionary(zip(simulatorIds, configs), uniquingKeysWith: { val, _ in val })
        configureSimulators(simulatorConfigs: simulatorConfigs)

        let testsResults = runTests(simulatorIds: simulatorIds)

        deleteSimulators(ids: simulatorIds)

        guard testsResults == EXIT_SUCCESS else {
            exit(testsResults)
        }

        extractScreenshots(simulatorConfigs: simulatorConfigs)
        generateScreenshotsPage()

        let duration = Date().timeIntervalSince(startDate)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.hour, .minute, .second]
        print("Generating screenshots took: \(formatter.string(from: duration)!)")
    }

    /// Creates simulators for each config
    /// - Parameter configs: the configs
    /// - Returns: a tuple containing the exit result of the command and the list of simulators ids
    private static func createSimulators(configs: [SimulatorConfig]) -> (Int32, [String]) {
        var simulatorIds = [String]()
        print("Creating Simulators:")
        for config in configs {
            print("   Creating simulator with config \(config)")
            var simulatorId = ""
            let result = try? Command.run(
                "xcrun simctl create \(config.simulatorName) \"\(config.model.name)\" \(config.os.name)") {
                    print("\($0)")
                    simulatorId = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            guard result == EXIT_SUCCESS && !simulatorId.isEmpty else {
                return (result ?? EXIT_FAILURE, simulatorIds)
            }
            print("   => Created \(simulatorId)")
            simulatorIds.append(simulatorId)
        }

        return (EXIT_SUCCESS, simulatorIds)
    }

    /// Configure the simulators
    /// - Parameters:
    ///   - simulatorIds: list of the simulators ids
    ///   - configs: list of configs
    private static func configureSimulators(simulatorConfigs: [String: SimulatorConfig]) {
        print("Booting Simulators")
        for simulatorId in simulatorConfigs.keys {
            Command.runAndPrint("xcrun simctl boot \(simulatorId)")
        }

        print("Configuring Simulators")
        for (simulatorId, config) in simulatorConfigs {
            Command.runAndPrint(
                "xcrun simctl status_bar \(simulatorId) override " +
                "--time \"3:13 PM\" " +
                "--dataNetwork wifi " +
                "--wifiMode active " +
                "--wifiBars 3 " +
                "--cellularMode notSupported " +
                "--batteryState discharging " +
                "--batteryLevel 100"
            )

            Command.runAndPrint("xcrun simctl ui \(simulatorId) appearance \(config.appearance.name)")
            Command.runAndPrint("xcrun simctl ui \(simulatorId) content_size \(config.contentSize.name)")
        }
    }

    /// Delete the simulators
    /// - Parameter ids: the list of simulators ids to delete
    private static func deleteSimulators(ids: [String]) {
        print("Deleting Simulators")
        for simulatorId in ids {
            Command.runAndPrint("xcrun simctl delete \(simulatorId)")
        }
    }

    /// Run the Screenshots UITests
    /// - Parameter simulatorIds: list of simulators ids to run the tests on
    /// - Returns: the exit code of the tests
    private static func runTests(simulatorIds: [String]) -> Int32 {
        print("Running Screenshots Tests")
        return Command.runAndPrint(
            "xcodebuild test -project Fruta.xcodeproj " +
            "-scheme FrutaScreenshotsTests " +
            "-testPlan FrutaScreenshotsTests " +
            "-resultBundlePath \(latestScreenshotsResultsPath) " +
            "-parallel-testing-enabled YES " +
            "-parallel-testing-worker-count \(simulatorIds.count) " +
            "\(simulatorIds.map { "-destination \"id=\($0)\"" }.joined(separator: " "))"
        )
    }

    /// Extract screenshots files from the xctestsresults file
    private static func extractScreenshots(simulatorConfigs: [String: SimulatorConfig]) {
        print("Extracting Screenshots")
        Command.runAndPrint("rm -rf \(screenshotsPageFolder)")
        Command.runAndPrint("mkdir -p \(screenshotsPageFolder)")

        let screenshotFolderUrl = URL(filePath: screenshotsPageFolder)
        let screenshotsPageFolderTmp = screenshotFolderUrl.appendingPathComponent("tmp")
        let fileManager = FileManager.default
        do {
            // first clean the destination in case there is already data in it
            try fileManager.removeItem(at: screenshotFolderUrl)

            try fileManager.createDirectory(at: screenshotsPageFolderTmp, withIntermediateDirectories: true)
            // extract screenshots by device identifier and test plan config
            // this will create a folder tree like that:
            // DEVICE_ID_1
            //     en_US
            //        screenshots of this device in this language
            //     fr_FR
            //        screenshots of this device in this language
            // DEVICE_ID_2
            //     en_US
            //        screenshots of this device in this language
            //     fr_FR
            //        screenshots of this device in this language
            Command.runAndPrint("./ScreenshotsGenerator/.build/release/xcparse screenshots " +
                                "--identifier --test-plan-config " +
                                "\(latestScreenshotsResultsPath) \(screenshotsPageFolderTmp.relativePath)")

            let deviceFolders = try fileManager.contentsOfDirectory(
                at: screenshotsPageFolderTmp, includingPropertiesForKeys: [.isDirectoryKey])
                .filter { try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false }

            // replace the device identifier by a device display name and move it to `screenshotFolderUrl`
            for deviceFolder in deviceFolders {
                let simulatorId = deviceFolder.lastPathComponent
                guard let config = simulatorConfigs[simulatorId] else {
                    print("Simulator with id \(simulatorId) not found")
                    continue
                }

                let deviceScreenshotsUrl = screenshotFolderUrl.appendingPathComponent(config.displayName)
                try fileManager.moveItem(at: deviceFolder, to: deviceScreenshotsUrl)
            }

            try fileManager.removeItem(at: screenshotsPageFolderTmp)
        } catch {
            print("Error while extracting screenshots: \(error)".foreColor(9))
        }
    }

    /// Generates an html file listing all the screenshots
    private static func generateScreenshotsPage() {
        print("Writing html file")
        var htmlStr = """
            <html>
                <head>
                    <style>
                        img {
                            max-width:180px;
                            width:auto;
                            height:auto;
                            padding: 5px;
                        }
                        div { white-space:nowrap; }
                        .carousel {
                            display: flex;
                            flex-flow: row;
                        }
                        .tab { margin-left: 40px; }
                        .imageBlock {
                            padding: 5px;
                            max-width:180px;
                            flex-flow: column;
                            white-space:nowrap;
                        }
                        .text {
                            overflow: hidden;
                            text-align: center;
                        }
                    </style>
                </head>
                <body>
                    <div>

            """

        do {
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: screenshotsPageFolder, withIntermediateDirectories: true)
            let screenshotFolderUrl = URL(filePath: screenshotsPageFolder)
            let htmlPageUrl = screenshotFolderUrl.appendingPathComponent("index.html")

            let deviceFolders = try fileManager.contentsOfDirectory(
                at: screenshotFolderUrl, includingPropertiesForKeys: [.isDirectoryKey])
                .filter { try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false }
                .sorted { $0.lastPathComponent < $1.lastPathComponent }
            for deviceFolder in deviceFolders {
                let deviceName = deviceFolder.lastPathComponent
                htmlStr += "\t\t\t<p>\(deviceName)</p>\n"
                htmlStr += "\t\t\t<div class=\"tab\">\n"

                let languageFolders = try fileManager.contentsOfDirectory(
                    at: deviceFolder, includingPropertiesForKeys: [.isDirectoryKey])
                    .filter { try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false }
                    .sorted { $0.lastPathComponent < $1.lastPathComponent }

                for languageFolder in languageFolders {
                    let language = languageFolder.lastPathComponent
                    htmlStr += "\t\t\t\t<p>\(language)</p>\n"
                    htmlStr += "\t\t\t\t<div class=\"carousel\">\n"

                    let imagesFolder = try fileManager.contentsOfDirectory(
                        at: languageFolder, includingPropertiesForKeys: nil)
                        .filter { $0.pathExtension == "png" }
                        .sorted { $0.lastPathComponent < $1.lastPathComponent }

                    for image in imagesFolder {
                        htmlStr += "\t\t\t\t\t<div class=\"imageBlock\">\n"
                        htmlStr += "\t\t\t\t\t\t<img src=\"\(image.relativePath(from: screenshotFolderUrl)!)\">\n"
                        htmlStr += "\t\t\t\t\t\t<div class=\"text\">\n"
                        htmlStr += "\t\t\t\t\t\t\t\(screenshotName(image))\n"
                        htmlStr += "\t\t\t\t\t\t</div>\n"
                        htmlStr += "\t\t\t\t\t</div>\n"
                    }
                    htmlStr += "\t\t\t\t</div>\n"
                }
                htmlStr += "\t\t\t</div>\n"
            }

            htmlStr += """
                    </div>
                </body>
            </html>
            """

            try htmlStr.write(to: htmlPageUrl, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Error while writing html page: \(error)".foreColor(9))
        }
    }

    private static func screenshotName(_ fileUrl: URL) -> String {
        String(fileUrl.lastPathComponent.split(separator: "_")[0].suffix(from: 4))
    }
}

private extension SimulatorConfig {
    var simulatorName: String {
        "\"Scr \(model.name) \(appearance.displayName) \(contentSize.displayName)\""
    }
}

private extension SimulatorConfig.Model {
    var name: String {
        switch self {
        case .iPhone14:         return "iPhone 14"
        case .iPhone8:          return "iPhone 8"
        case .iPhoneX:          return "iPhone X"
        case .iPhoneSE2:        return "iPhone SE (2nd generation)"
        case .iPhone14Pro:      return "iPhone 14 Pro"
        case .iPhone14ProMax:   return "iPhone 14 Pro Max"
        }
    }
}

private extension SimulatorConfig.OS {
    var name: String {
        switch self {
        case .iOS16:      return "" // empty string so xcrun will take the latest os available
        case .iOS15:      return "iOS15.5"
        case .iOS14:      return "iOS14.5"
        }
    }

    var displayName: String {
        switch self {
        case .iOS16:      return "(16.X)"
        case .iOS15:      return "(15.5)"
        case .iOS14:      return "(14.5)"
        }
    }
}

private extension SimulatorConfig.Appearance {
    var name: String {
        switch self {
        case .light:    return "light"
        case .dark:     return "dark"
        }
    }

    var displayName: String {
        switch self {
        case .light:    return "Light"
        case .dark:     return "Dark"
        }
    }
}

private extension SimulatorConfig.ContentSize {
    var name: String {
        switch self {
        case .extraSmall:       return "extra-small"
        case .small:            return "small"
        case .medium:           return "medium"
        case .large:            return "large"
        case .extraLarge:       return "extra-large"
        case .extraExtraLarge:  return "extra-extra-large"
        }
    }

    var displayName: String {
        switch self {
        case .extraSmall:       return "XS"
        case .small:            return "S"
        case .medium:           return "M"
        case .large:            return "L"
        case .extraLarge:       return "XL"
        case .extraExtraLarge:  return "XXL"
        }
    }
}

private extension URL {
    func relativePath(from base: URL) -> String? {
        // Ensure that both URLs represent files:
        guard self.isFileURL && base.isFileURL else {
            return nil
        }

        // Remove/replace "." and "..", make paths absolute:
        let destComponents = self.standardized.pathComponents
        let baseComponents = base.standardized.pathComponents

        // Find number of common path components:
        var i = 0
        while i < destComponents.count && i < baseComponents.count && destComponents[i] == baseComponents[i] {
            i += 1
        }

        // Build relative path:
        var relComponents = Array(repeating: "..", count: baseComponents.count - i)
        relComponents.append(contentsOf: destComponents[i...])
        return relComponents.joined(separator: "/")
    }
}

private extension SimulatorConfig {
    var displayName: String {
        return "\(model.name) \(os.displayName) \(appearance.displayName) \(contentSize.displayName)"
    }
}
