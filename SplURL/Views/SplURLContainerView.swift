//
//  SplURLContainerView.swift
//  SplURL
//
//  Created by Christopher Brind on 02/07/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI

struct SplURLContainerView: View {

    @ObservedObject var model: Model

    var pasteAction: () -> Void
    var closeAction: (() -> Void)?

    var body: some View {
        VStack {
            if closeAction != nil {
                HStack {
                    Spacer()
                    Button("Done") {
                        closeAction?()
                    }
                }
                .padding([.top, .trailing, .leading])
            }

            List {
                Section(header:
                    HStack {
                        Image(systemName: model.parts.isEmpty ? "doc.on.clipboard" : "globe")
                        Text(model.url ?? "Use the menu to paste a URL from the clipboard.")
                    }
                ) {
                    ForEach(model.parts) { part in
                        PartView(part: part)
                    }
                }
            }
            .listStyle(.inset)            
        }
        .buttonStyle(BorderlessButtonStyle())
    }

}


struct PartView: View {

    var part: String

    @State var tapped: Bool = false

    var body: some View {
        HStack {
            Text(part)
            Spacer()
            if !part.isEmpty {
                Menu {
                    Button(action: {
                        // TODO copy
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                }
                label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }

}

extension String: Identifiable {
    public var id: String {
        return self
    }
}

extension Int {
    var string: String {
        return "\(self)"
    }
}
