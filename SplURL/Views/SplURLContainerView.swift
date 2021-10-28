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

                ForEach(model.sections) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.parts) { part in
                            PartView(model: part) {
                                model.remove(part: part)
                            }
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

extension Int {
    var string: String {
        return "\(self)"
    }
}
