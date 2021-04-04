//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: UIViewController {

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {

    }
}
