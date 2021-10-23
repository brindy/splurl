//
//  SceneDelegate.swift
//  SplURL
//
//  Created by Christopher Brind on 29/06/2020.
//  Copyright © 2020 Christopher Brind. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let model = Model(extraSpace: false)
        model.showWelcome = WelcomeManager().shouldShow()
        let contentView = ContentView(model: model)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }

        NotificationCenter.default.addObserver(forName: .OpenedWithText, object: nil, queue: nil) { notification in
            let text = notification.object as? String
            print("opened with text", text as Any)
            contentView.model.url = text
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(#function)
        guard let url = URLContexts.first?.url else { return }
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach { item in
            guard item.name == "text" else { return  }
            guard let text = item.value else { return }
            NotificationCenter.default.post(name: .OpenedWithText, object: text)
        }
    }

}

