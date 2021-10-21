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

    var clearAction: () -> Void

    var body: some View {
        VStack {
            HStack(alignment: .center) {

                if model.url == nil {
                    Text("Use")
                    Image(systemName: "doc.on.clipboard")
                    Text("to paste from the clipboard")
                }

                Text(model.url ?? "").padding([.top, .bottom], 8)

                if model.url != nil {

                    Spacer()

                    Button(action: clearAction) {
                        Image(systemName: "clear")
                    }.padding([.trailing], 16)

                }

            }.padding([.leading, .trailing], 12)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                .background(Color(UIColor.systemBackground).shadow(color: Color(UIColor.secondarySystemFill), radius: 1, x: 0, y: 2))

            List {
                ForEach(model.parts + [""]) { part in
                    PartView(part: part)
                }
            }.background(Color.secondary)

        }.buttonStyle(BorderlessButtonStyle())
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
                Button(action: {
                    self.tapped = true
                }) {
                    Image(systemName: "square.and.arrow.up").padding()
                }
            }
        }
        .padding([.leading, .trailing], 12)
        .sheet(isPresented: $tapped) {
            ShareSheet(activityItems: [self.part])
        }
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
