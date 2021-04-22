//
//  AppDelegate.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import GoogleMaps
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let googleApiKey = "AIzaSyBSVR9G-xtpqeAJW9QH18GmeSyiRbWd7H0"
        GMSServices.provideAPIKey(googleApiKey)
        FirebaseApp.configure()

        let navBar = UINavigationBar.appearance()
        let textAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.brownRed,
                                                            .font: UIFont.applyCustomFont(name: "Caveat-Regular", size: 25)]
        navBar.barTintColor = FSColors.whitePink
        navBar.tintColor = FSColors.mainPink
        navBar.titleTextAttributes = textAttribute

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
