//
//  FSTabBarController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSTabBarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTabBar()

    }

    private func createTabBar() {
        let tabBarController = UITabBarController()

        let shopController = FSShopController()
        shopController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)

        let cartController = FSCartController()

        let mapController = FSMapController()

        let profileController = FSProfileController()

        tabBarController.setViewControllers([
            shopController,
            cartController,
            mapController,
            profileController
        ], animated: true)
    }
}
