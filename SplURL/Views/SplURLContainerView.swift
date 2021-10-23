//
//  SplURLContainerView.swift
//  SplURL
//
//  Created by Christopher Brind on 02/07/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI
import UIKit

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

                ForEach(model.parts) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.parts) { part in
                            PartView(model: part)
                        }
                    }
                }

            }
            .listStyle(.inset)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(EdgeInsets(top: 0, leading: 0, bottom: model.extraSpace ? 40 : 0, trailing: 0))
    }

}


struct PartView: View {

    var model: Model.PartModel

    @State var tapped: Bool = false

    var body: some View {
        HStack {
            Text(model.asString)

            Spacer()
            Menu {
                Button(action: {
                    UIPasteboard.general.string = model.asString
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
