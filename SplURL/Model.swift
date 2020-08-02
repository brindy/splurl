//
//  Model.swift
//  SplURL
//
//  Created by Christopher Brind on 02/08/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import Foundation

class Model: ObservableObject {

    struct SettingsKeys {
        static let showWelcome = "settings.showWelcome"
    }

    @Published var showWelcome: Bool = UserDefaults.standard.object(forKey: SettingsKeys.showWelcome) as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(false, forKey: SettingsKeys.showWelcome)
        }
    }

    @Published var showSheet: Bool = UserDefaults.standard.object(forKey: SettingsKeys.showWelcome) as? Bool ?? true

    @Published var url: String? {
        didSet {
            print("didSet url", url as Any)
            parts = createParts()
        }
    }

    @Published var parts: [String] = [] {
        didSet {
            print("didSet parts", parts)
        }
    }

    func createParts() -> [String] {
        guard let urlString = url, let url = URL(string: urlString) else { return [] }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        let paths = components?.path
            .components(separatedBy: "/")
            .map { $0.components(separatedBy: "&") }
            .flatMap { $0 }
            .map { $0.components(separatedBy: "=") }
            .flatMap { $0 }
            ?? []

        let queryItems = components?.queryItems?
            .map{ [$0.name, $0.value] }
            .flatMap{ $0 }
            .compactMap{ $0 } ?? []

        let fragments = components?.fragment?
            .components(separatedBy: "/")
            .map { $0.components(separatedBy: "&") }
            .flatMap { $0 }
            .map { $0.components(separatedBy: "=") }
            .flatMap { $0 }
            ?? []

        let parts: [String?] = [ components?.scheme,
                                 components?.user,
                                 components?.password,
                                 components?.host,
                                 components?.port?.string ]
            + (paths)
            + (queryItems)
            + (fragments)

        return parts.compactMap { $0?.isEmpty ?? true ? nil : $0 }
    }

}
