//
//  HostController.swift
//  OpenInAction
//
//  Created by Christopher Brind on 02/07/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import UIKit
import SwiftUI
import MobileCoreServices

class HostController: UIViewController {

    let model = Model(extraSpace: true)

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootView = SplURLContainerView(model: model, pasteAction: {
            print("paste")
        }) {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }.environmentObject(ContextModel(isApp: false))

        let childView = UIHostingController(rootView: rootView)
        addChild(childView)
        childView.view.frame = view.frame
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for item in extensionContext?.inputItems as? [NSExtensionItem] ?? [] {
            for provider in item.attachments ?? [] {

                if provider.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { item, _ in
                        guard let text = item as? String else { return }
                        self.setText(text)
                    })
                    break
                }

                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { item, _ in
                        guard let text = (item as? URL)?.absoluteString else { return }
                        self.setText(text)
                    })
                    break
                }
            }

         }

    }

    func setText(_ text: String) {
        DispatchQueue.main.async {
            self.model.url = text
        }
    }


}
