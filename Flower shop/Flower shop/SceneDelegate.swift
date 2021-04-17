//
//  SceneDelegate.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = scene
        window.makeKeyAndVisible()

        let tabBarVC = FSTabBarController()
        let authVC = FSAuthorizationController()
        window.rootViewController = (Auth.auth().currentUser != nil) ? tabBarVC : authVC

        self.window = window
    }

    func changeRootViewConroller(_ vc: UIViewController, animated: Bool = false) {
        guard let window = self.window else { return }
        window.rootViewController = vc
    }
}
