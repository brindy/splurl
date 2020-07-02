//
//  ActionRequestHandler.swift
//  OpenInAction
//
//  Created by Christopher Brind on 02/07/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for item in extensionContext?.inputItems as? [NSExtensionItem] ?? [] {
            for provider in item.attachments ?? [] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: { item, _ in
                        guard let text = (item as? URL)?.absoluteString ?? item as? String else { return }
                        DispatchQueue.main.async {
                            self.launch(with: text)
                            self.done()
                        }
                    })
                    break
                }
            }
        }
    }

    func launch(with text: String) {

        let path = "splurl://?text=\(text)"
        guard let url = URL(string: path) else { return }
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        while let current = responder {
            if current.responds(to: selectorOpenURL) {
                current.perform(selectorOpenURL, with: url, afterDelay: 0)
                break
            }
            responder = current.next
        }
    }

    func done() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

}
