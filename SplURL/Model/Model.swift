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
            sections = createSections()
        }
    }

    @Published var sections: [PartSectionModel] = [PartSectionModel(nameFactory: {_ in "Use the menu to paste a URL"}, parts: [])] {
        didSet {
            print("didSet parts", sections)
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

        let id: String
        let nameFactory: ([PartModel]) -> String

        var name: String { nameFactory(parts) }

        var parts: [PartModel]

        init(id: String = UUID().uuidString, nameFactory: @escaping ([PartModel]) -> String, parts: [PartModel]) {
            self.id = id
            self.nameFactory = nameFactory
            self.parts = parts
        }

        func removingPart(_ part: PartModel) -> PartSectionModel {
            let parts: [PartModel]

            if case .queryParameterName(name) = part.part, let nameIndex = self.parts.firstIndex(where: { $0.id == part.id }) {
                var editable = self.parts
                editable.remove(at: nameIndex)
                editable.remove(at: nameIndex)
                parts = editable
            } else {
                parts = self.parts.filter { $0.id != part.id }
            }
            return PartSectionModel(id: id, nameFactory: nameFactory, parts: parts)
        }

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
            case .queryParameterName: return "="
            case .queryParameterValue: return "&"
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

    func remove(part: PartModel) {
        guard let section = sections.first(where: { $0.parts.contains(where: { $0.id == part.id }) }) else { return }
        let updated = section.removingPart(part)
        if updated.parts.isEmpty {
            self.sections = self.sections.filter { $0.id != section.id }
        } else {
            self.sections = self.sections.map { $0.id == section.id ? updated : $0 }
        }
    }

    private func createSections() -> [PartSectionModel] {
        guard let urlString = url, let url = URL(string: urlString) else {
            return [
                PartSectionModel(nameFactory: { _ in "No URL in clipboard" }, parts: [])
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
            result.append(PartSectionModel(nameFactory: { parts in parts.map { $0.prefix + $0.asString + $0.suffix }.joined(separator: "") }, parts: parts))
        }

        if let paths = components?.path.components(separatedBy: "/") {
            let parts = paths.filter { !$0.isEmpty }.map { PartModel(part: .path($0)) }
            if !parts.isEmpty {
                result.append(PartSectionModel(nameFactory: { parts in parts.map { "/" + $0.asString }.joined() }, parts: parts))
            }
        }

        if let queryItems = components?.queryItems, !queryItems.isEmpty {
            let parts = queryItems.flatMap {
                [
                    PartModel(part: .queryParameterName($0.name)),
                    $0.value.map { PartModel(part: .queryParameterValue($0)) }
                ].compactMap {
                    $0
                }.filter {
                    $0.asString != ""
                }
            }

            result.append(PartSectionModel(nameFactory: { parts in
                return "?" + self.nameValuesFrom(parts).joined(separator: "&")
            }, parts: parts))
        }

        if let fragment = components?.fragment, !fragment.isEmpty {
            let parts = fragment.components(separatedBy: "/").map { PartModel(part: .fragment(value: $0)) }
            result.append(PartSectionModel(nameFactory: { parts in "#" + parts.map { $0.asString }.joined(separator: "/") }, parts: parts))
        }

        return result
    }

    private func nameValuesFrom(_ models: [PartModel]) -> [String] {

        var parts = [String]()
        var previousPair: (name: String, value: String)?

        (0 ..< models.count).forEach {
            switch models[$0].part {
            case .queryParameterName(let name):
                if let pair = previousPair {
                    parts.append(pair.name + "=" + pair.value)
                }
                previousPair = (name: name, value: "")

            case .queryParameterValue(let value):
                previousPair?.value = value
                if let pair = previousPair {
                    parts.append(pair.name + "=" + pair.value)
                    previousPair = nil
                }

            default: assertionFailure("unexpected part")
            }
        }

        if let pair = previousPair {
            parts.append(pair.name + "=" + pair.value)
        }

        return parts
    }

    func buildURL() -> Any {
        let urlString = sections.map { $0.name }.joined()
        if let url = URL(string: urlString) {
            return url
        } else {
            return urlString
        }
    }

}
