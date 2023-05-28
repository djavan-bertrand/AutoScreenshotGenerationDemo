//
//  Copyright © 2023 Tag Heuer Connected. All rights reserved.
//

import Foundation

/// A simulator configuration
struct SimulatorConfig {
    /// Model of a simulator
    enum Model: CaseIterable {
        case iPhone8
        case iPhoneX
        case iPhoneSE2
        case iPhone14
        case iPhone14Pro
        case iPhone14ProMax
    }

    /// OS of the simulator
    enum OS: CaseIterable {
        case iOS16
        case iOS15
        case iOS14

        static var defaultValue: OS { .iOS16 }
    }

    /// Appearance of the simulator
    enum Appearance: CaseIterable {
        case light
        case dark

        static var defaultValue: Appearance { .light }
    }

    /// Content size of the simulator
    enum ContentSize: CaseIterable {
        case extraSmall
        case small
        case medium
        case large
        case extraLarge
        case extraExtraLarge

        static var defaultValue: ContentSize { .large }
    }

    let model: Model
    let os: OS
    let appearance: Appearance
    let contentSize: ContentSize
}
