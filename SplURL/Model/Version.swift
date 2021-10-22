//
//  Version.swift
//  SplURL
//
//  Created by Christopher Brind on 22/10/2021.
//  Copyright © 2021 Christopher Brind. All rights reserved.
//

import Foundation

struct Version {

    static var short: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

}
