//
//  WelcomeManager.swift
//  SplURL
//
//  Created by Christopher Brind on 21/10/2021.
//  Copyright © 2021 Christopher Brind. All rights reserved.
//

import Foundation

class WelcomeManager {

    struct Constants {
        static let welcomeVersionKey = "welcome.version"
        static let welcomeVersion = 1
    }

    func shouldShow() -> Bool {
        var show = false
        let showWelcome: Int = UserDefaults.standard.object(forKey: Constants.welcomeVersionKey) as? Int ?? 0
        if showWelcome < Constants.welcomeVersion {
            show = true
            UserDefaults.standard.set(Constants.welcomeVersion, forKey: Constants.welcomeVersionKey)
        }
        return show
    }

}
