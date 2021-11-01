//
//  WelcomeView.swift
//  SplURL
//
//  Created by Christopher Brind on 22/10/2021.
//  Copyright © 2021 Christopher Brind. All rights reserved.
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
