//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//

import Foundation

/// Utility class to run shell commands
enum Command {

    /// If true, each command will be printed before being executed
    static let verbose = true

    /// Run a command
    /// - Parameters:
    ///   - command: the command to run
    ///   - outputByLineCb: block called each time the command generates an output
    /// - Returns: the command exit code
    @discardableResult static func run(_ command: String,
                                       outputByLineCb: @escaping (String) -> Void) throws -> Int32 {
        if verbose {
            print(" > Running cmd: \(command)".italic)
        }
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        let outputHandler = pipe.fileHandleForReading
        outputHandler.waitForDataInBackgroundAndNotify()

        var dataObserver: NSObjectProtocol!
        let notificationCenter = NotificationCenter.default
        let dataNotificationName = NSNotification.Name.NSFileHandleDataAvailable
        dataObserver = notificationCenter.addObserver(
            forName: dataNotificationName, object: outputHandler, queue: nil) { notification in
                let data = outputHandler.availableData
                guard data.count > 0 else {
                    return
                }
                if let line = String(data: data, encoding: .utf8) {
                    outputByLineCb(line)
                }
                outputHandler.waitForDataInBackgroundAndNotify()
            }

        try task.run()
        task.waitUntilExit()
        notificationCenter.removeObserver(dataObserver!)
        return task.terminationStatus
    }

    /// Runs a command and print its output
    /// - Parameter command: the command to run
    /// - Returns: the command exit code
    @discardableResult static func runAndPrint(_ command: String) -> Int32 {
        do {
            return try run(command) { print($0) }
        } catch {
            print("Error: \(error)".foreColor(9))
            return EXIT_FAILURE
        }
    }
}
