//
//  SceneDelegate.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = FSTabBarController()
        window.windowScene = scene
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        self.window = window
    }

    func changeRootViewConroller(_ vc: UIViewController, animated: Bool = false) {
        guard let window = self.window else { return }
        window.rootViewController = vc
    }
}
