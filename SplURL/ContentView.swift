//
//  ContentView.swift
//  SplURL
//
//  Created by Christopher Brind on 29/06/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI

struct PartView: View {

    var part: String

    @State var tapped: Bool = false

    var body: some View {
        HStack {
            Text(part)
            Spacer()

            Button(action: {
                self.tapped = true
            }) {
                Image(systemName: "square.and.arrow.up").padding()
            }
        }
        .padding([.leading, .trailing], 12)
        .sheet(isPresented: $tapped) {
            ShareSheet(activityItems: [self.part])
        }
    }

}

struct AboutView: View {

    var body: some View {
        VStack {
            Text("About 👀").font(.title)
            Spacer()
        }
    }

}

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
                Text("Or from another app share some text or a link and use Open in SplURL to launch the app and automatically split up the first URL found.  Very cool! 😎")
                    .font(.body)
                    .padding()
            }

            Spacer()

        }

    }

}

struct ContentView: View {

    @State var url: String? {
        didSet {
            parts = createParts()
        }
    }

    @State var parts: [String] = []

    @State var showSheet = true
    @State var showWelcome = true

    var body: some View {
        VStack {
            HStack {
                Text("SplURL - the URL splitter").font(.headline)

                Spacer()

                Button(action: tapPaste) {
                    Image(systemName: "doc.on.clipboard")
                }.padding([.trailing], 12)

                Button(action: {
                    print("More pressed")
                    self.showSheet = true
                }) {
                    Image(systemName: "ellipsis.circle")
                }.padding([.trailing], 12)
            }.padding([.top, .trailing, .leading])

            HStack(alignment: .center) {

                if url == nil {
                    Text("Use")
                    Image(systemName: "doc.on.clipboard")
                    Text("to paste from the clipboard")
                }

                Text(url ?? "").padding([.top, .bottom], 8)

                if url != nil {

                    Spacer()

                    Button(action: {
                        print("Clear pressed")
                        self.url = nil
                    }) {
                        Image(systemName: "clear")
                    }.padding([.trailing], 16)

                }

            }.padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                .background(Color(UIColor.systemBackground).shadow(color: Color(UIColor.secondarySystemFill), radius: 1, x: 0, y: 2))

            ScrollView {
                ForEach(parts) { part in
                    PartView(part: part)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .sheet(isPresented: $showSheet) {

                VStack {
                    HStack {
                        Spacer()
                        Button("Done", action: {
                            print("Done pressed")
                            self.showSheet = false
                            self.showWelcome = false
                        })
                    }

                    Spacer()

                    if self.showWelcome {

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

        let delay = self.url == nil ? 0.0 : 0.3

        self.url = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let urlString = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            var url = URL(string: urlString)

            if url == nil {
                let potential = urlString.components(separatedBy: .whitespacesAndNewlines).first(where: {
                    $0.hasPrefix("http://") || $0.hasPrefix("https://")
                })
                url = URL(string: potential ?? "")
            }

            self.url = url?.absoluteString ?? "No URL in the clipboard"
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

// https://developer.apple.com/forums/thread/123951
struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
