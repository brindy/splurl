//
//  AboutView.swift
//  SplURL
//
//  Created by Christopher Brind on 02/07/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import SwiftUI

struct AboutView: View {

    var body: some View {
        VStack {

            Text("SplURL - the URL splitter").font(.title)

            Image(systemName: "link").padding(48)

            Text("(c) 2020 Brindy").padding()

            Button("https://github.com/brindy/splurl") {
                UIApplication.shared.open(URL(string: "https://github.com/brindy/splurl")!)
            }

            Spacer()

            Text("Inspired by Russell Holt").padding()
        }
    }

}
