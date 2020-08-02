//
//  ContentView.swift
//  SplURL
//
//  Created by Christopher Brind on 29/06/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {

    var body: some View {

        VStack {

            Text("Welcome! 👋")
                .font(.largeTitle)
                .padding()

            HStack {
                Image(systemName: "doc.on.clipboard")
                Text("Paste text from the clipboard and SplURL will pull out the first URL it finds, split it up into parts and show it in the list.  Easy! 🥧")
                    .font(.body)
                    .padding()
            }

            HStack {
                Image(systemName: "link")
                Text("Or from another app, share some text or a link and use Open in SplURL to automatically split up the first URL found.  Very cool! 😎")
                    .font(.body)
                    .padding()
            }

            Spacer()

        }

    }

}

struct ContentView: View {

    @ObservedObject var model: Model

    var body: some View {
        VStack {
            HStack {
                Text("SplURL - the URL splitter").font(.system(size: 16, weight: .bold))

                Spacer()

                Button(action: tapPaste) {
                    Image(systemName: "doc.on.clipboard")
                }.padding([.trailing], 12)

                Button(action: {
                    print("More pressed")
                    self.model.showSheet = true
                }) {
                    Image(systemName: "ellipsis.circle")
                }.padding([.trailing], 12)
            }.padding([.top, .trailing, .leading])

            SplURLContainerView(model: model, clearAction: {
                print("Clear pressed")
                self.model.url = nil
            })
                .sheet(isPresented: $model.showSheet) {

                    VStack {
                        HStack {
                            Spacer()
                            Button("Done", action: {
                                print("Done pressed")
                                self.model.showSheet = false
                                self.model.showWelcome = false
                            })
                        }

                        Spacer()

                        if self.model.showWelcome {

                            WelcomeView()

                        } else {

                            AboutView()

                        }

                        Spacer()

                    }.padding()
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
        ContentView(model: Model())
            .environment(\.colorScheme, .dark)
    }
}
