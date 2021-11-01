//
//  PartView.swift
//  SplURL
//
//  Created by Christopher Brind on 23/10/2021.
//  Copyright © 2021 Christopher Brind. All rights reserved.
//

import SwiftUI

struct PartView: View {

    @EnvironmentObject
    var contextModel: ContextModel

    var model: Model.PartModel

    @State var tapped: Bool = false

    var removeAction: () -> Void

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

                if contextModel.isApp {
                    Button(action: {
                        removeAction()
                    }) {
                        Label("Remove", systemImage: "delete.left")
                    }
                }
            }
            label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }

}
