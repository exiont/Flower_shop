//
//  FSTabBarController.swift
//  Flower shop
//
//  Created by New on 25.03.21.
//

import UIKit
import FirebaseAuth

class FSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupTabBar()
        self.customizeTabBar()
    }

    private func setupTabBar() {
        let shopController = FSShopController()
        shopController.tabBarItem = UITabBarItem(title: "Магазин",
                                                 image: UIImage(systemName: "house"),
                                                 selectedImage: UIImage(systemName: "house.fill"))

        let cartController = FSCartController()
        cartController.tabBarItem = UITabBarItem(title: "Корзина",
                                                 image: UIImage(systemName: "cart"),
                                                 selectedImage: UIImage(systemName: "cart.fill"))

        let mapController = FSMapViewController()
        mapController.tabBarItem = UITabBarItem(title: "Карта",
                                                image: UIImage(systemName: "map"),
                                                selectedImage: UIImage(systemName: "map.fill"))

        let profileController = FSProfileController()
        profileController.tabBarItem = UITabBarItem(title: "Профиль",
                                                    image: UIImage(systemName: "person"),
                                                    selectedImage: UIImage(systemName: "person.fill"))

        self.setViewControllers([
            UINavigationController(rootViewController: shopController),
            UINavigationController(rootViewController: cartController),
            UINavigationController(rootViewController: mapController),
            UINavigationController(rootViewController: profileController)
        ], animated: true)
    }

    private func customizeTabBar() {
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = FSColors.mainPink
        self.tabBar.barTintColor = FSColors.whitePink
    }
}
