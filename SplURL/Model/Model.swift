//
//  Model.swift
//  SplURL
//
//  Created by Christopher Brind on 02/08/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import Foundation
import SwiftUI

class Model: ObservableObject {

    let extraSpace: Bool

    @Published var showWelcome: Bool = false

    @Published var showAbout: Bool = false

    @Published var url: String? {
        didSet {
            print("didSet url", url as Any)
            parts = createParts()
        }
    }

    @Published var parts: [PartSectionModel] = [PartSectionModel(name: "Use the menu to paste a URL", parts: [])] {
        didSet {
            print("didSet parts", parts)
        }
    }

    init(extraSpace: Bool) {
        self.extraSpace = extraSpace
    }

    enum Part {

        case scheme(String)
        case user(String)
        case password(String)
        case host(String)
        case port(Int)
        case path(String)
        case queryParameterName(String)
        case queryParameterValue(String)
        case fragment(value: String)
    }

    struct PartSectionModel: Identifiable {

        let id = UUID().uuidString

        let name: String
        let parts: [PartModel]

    }

    struct PartModel: Identifiable {

        let id = UUID().uuidString
        let part: Part

        var prefix: String {

            switch part {
            case .port: return ":"
            default: return ""
            }
            
        }

        var suffix: String {

            switch part {
            case .scheme: return "://"
            case .user: return ":"
            case .password: return "@"
            default: return ""
            }

        }

        var asString: String {

            switch part {
            case .scheme(let scheme): return scheme
            case .user(let user): return user
            case .password(let password): return password
            case .host(let host): return host
            case .port(let port): return "\(port)"
            case .path(let path): return path
            case .queryParameterName(let name): return name
            case .queryParameterValue(let value): return value
            case .fragment(let fragment): return fragment
            }

        }

    }

    func createParts() -> [PartSectionModel] {
        guard let urlString = url, let url = URL(string: urlString) else {
            return [
                PartSectionModel(name: "No URL in clipboard", parts: [])
            ]
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        var result = [PartSectionModel]()

        if components != nil {
            var parts = [PartModel]()
            if let scheme = components?.scheme {
                parts.append(PartModel(part: .scheme(scheme)))
            }
            if let user = components?.user {
                parts.append(PartModel(part: .user(user)))
            }
            if let password = components?.password {
                parts.append(PartModel(part: .password(password)))
            }
            if let host = components?.host {
                parts.append(PartModel(part: .host(host)))
            }
            if let port = components?.port {
                parts.append(PartModel(part: .port(port)))
            }
            result.append(PartSectionModel(name: parts.map { $0.prefix + $0.asString + $0.suffix }.joined(separator: ""), parts: parts))
        }

        if let paths = components?.path.components(separatedBy: "/") {
            let parts = paths.filter { !$0.isEmpty }.map { PartModel(part: .path($0)) }
            if !parts.isEmpty {
                result.append(PartSectionModel(name: components?.path ?? "", parts: parts))
            }
        }

        if let queryItems = components?.queryItems, !queryItems.isEmpty {
            let parts = queryItems.flatMap {
                [
                    PartModel(part: .queryParameterName($0.name)),
                    $0.value.map { PartModel(part: .queryParameterName($0)) }
                ].compactMap {
                    $0
                }
            }

            let sectionName = queryItems.map { $0.name + "=" + ($0.value ?? "")}.joined(separator: "&")
            result.append(PartSectionModel(name: "?" + sectionName, parts: parts))
        }

        if let fragment = components?.fragment, !fragment.isEmpty {
            let parts = fragment.components(separatedBy: "/").map { PartModel(part: .fragment(value: $0)) }
            result.append(PartSectionModel(name: "#" + fragment, parts: parts))
        }

        return result
    }

}
