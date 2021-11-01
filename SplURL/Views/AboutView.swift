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

            Image("Logo")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(8)

            Text("v" + Version.short + " - (c) 2021 Brindy").padding()

            Button("https://github.com/brindy/splurl") {
                UIApplication.shared.open(URL(string: "https://github.com/brindy/splurl")!)
            }

            Spacer()

            VStack(alignment: .center, spacing: 8) {
                Text("Inspired by Russell Holt")
                    .font(.footnote)
                Button("Logo by Mammoth Creative Works") {
                    UIApplication.shared.open(URL(string: "https://www.mammothcreativeworks.co.uk/")!)
                }.font(.footnote)
            }.padding()
        }
    }

}
