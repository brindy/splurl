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

    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()

        let childView = UIHostingController(rootView: SplURLContainerView(model: model, clearAction: {
            print("clear")
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }, pasteAction: {
            print("paste")            
        }))
        addChild(childView)
        childView.view.frame = view.frame
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
        
        _ = model.$url.sink { _ in
            print("sink", self.model.url as Any)
        }

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

            // self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }

    }

    func setText(_ text: String) {
        DispatchQueue.main.async {
            self.model.url = text
        }
    }


}
