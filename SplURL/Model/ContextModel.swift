//
//  ContextModel.swift
//  SplURL
//
//  Created by Christopher Brind on 28/10/2021.
//  Copyright © 2021 Christopher Brind. All rights reserved.
//

import Combine

class ContextModel: ObservableObject {

    @Published var isApp: Bool

    init(isApp: Bool) {
        self.isApp = isApp
    }

}
