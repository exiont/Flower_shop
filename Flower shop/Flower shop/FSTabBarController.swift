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
//        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }

    func setupTabBar() {
        let shopController = UINavigationController(rootViewController: FSShopController())

        let cartController = UINavigationController(rootViewController: FSCartController())

        let mapController = UINavigationController(rootViewController: FSMapController())

        let profileController = UINavigationController(rootViewController: FSProfileController())
        self.viewControllers = [
            shopController,
            cartController,
            mapController,
            profileController
        ]
    }
}
