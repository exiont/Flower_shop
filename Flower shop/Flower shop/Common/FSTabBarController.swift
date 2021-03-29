//
//  FSTabBarController.swift
//  Flower shop
//
//  Created by New on 25.03.21.
//

import UIKit

class FSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.view.backgroundColor = .white
    }

    func setupTabBar() {
        let shopController = FSShopController()
        shopController.tabBarItem = UITabBarItem(title: "Магазин",
                                                 image: UIImage(systemName: "house"),
                                                 selectedImage: UIImage(systemName: "house.fill"))

        let cartController = FSCartController()
        cartController.tabBarItem = UITabBarItem(title: "Корзина",
                                                 image: UIImage(systemName: "cart"),
                                                 selectedImage: UIImage(systemName: "cart.fill"))

        let mapController = FSMapController()
        mapController.tabBarItem = UITabBarItem(title: "Карта",
                                                image: UIImage(systemName: "map"),
                                                selectedImage: UIImage(systemName: "map.fill"))
        
        let profileController = FSProfileController()
        profileController.tabBarItem = UITabBarItem(title: "Профиль",
                                                    image: UIImage(systemName: "person"),
                                                    selectedImage: UIImage(systemName: "person.fill"))

        let authorizationController = FSAuthorizationController()
        authorizationController.tabBarItem = UITabBarItem(title: "Профиль",
                                                    image: UIImage(systemName: "person"),
                                                    selectedImage: UIImage(systemName: "person.fill"))

        self.setViewControllers([
            UINavigationController(rootViewController: shopController),
            UINavigationController(rootViewController: cartController),
            UINavigationController(rootViewController: mapController),
            UINavigationController(rootViewController: authorizationController)
        ], animated: true)

        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(named: "main_pink")
    }
}