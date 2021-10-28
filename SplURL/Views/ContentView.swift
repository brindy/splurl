//
//  ContentView.swift
//  SplURL
//
//  Created by Christopher Brind on 29/06/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var model: Model

    var shareAction: () -> Void
    var openAction: () -> Void
    var copyAction: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("SplURL - the URL splitter").font(.headline)
                Spacer()
                Menu {

                    if model.url != nil {
                        Button(action: {
                            copyAction()
                        }) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    }

                    Button(action: {
                        tapPaste()
                    }) {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }

                    Divider()

                    Button(action: {
                        shareAction()
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Button(action: {
                        openAction()
                    }) {
                        Label("Open", systemImage: "paperplane")
                    }

                    Divider()

                    Button(action: {
                        self.model.showWelcome = true
                    }) {
                        Label("Help", systemImage: "signpost.left")
                    }

                    Button(action: {
                        self.model.showAbout = true
                    }) {
                        Label("About", systemImage: "questionmark.square.dashed")
                    }

                }
                label: {
                    Image(systemName: "ellipsis.circle")
                }

            }.padding()

            SplURLContainerView(model: model, pasteAction: {
                print("Paste pressed")
                tapPaste()
            })
            .sheet(isPresented: $model.showWelcome) {
                VStack(alignment: .trailing) {
                    Button(action: {
                        self.model.showWelcome = false
                    }) {
                        Text("Done")
                    }.padding()
                    WelcomeView()
                        .padding()
                }
            }
            .sheet(isPresented: $model.showAbout) {
                VStack(alignment: .trailing) {
                    Button(action: {
                        self.model.showAbout = false
                    }) {
                        Text("Done")
                    }.padding()
                    AboutView()
                        .padding()
                }
            }
        }
    }

    func tapPaste() {
        let urlString = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        var url = URL(string: urlString)

        if url == nil {
            let potential = urlString.components(separatedBy: .whitespacesAndNewlines).first(where: {
                $0.hasPrefix("http://") || $0.hasPrefix("https://")
            })
            url = URL(string: potential ?? "")
        }

        self.model.url = url?.absoluteString ?? "No URL in the clipboard"
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: Model(extraSpace: false),
                    shareAction: {},
                    openAction: {},
                    copyAction: {}).environment(\.colorScheme, .dark)
    }
}
