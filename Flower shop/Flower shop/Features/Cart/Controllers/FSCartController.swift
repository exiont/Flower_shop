//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: FSViewController {

    var products: [FSProduct] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    func updateProductList(with product: FSProduct) {
        products.append(product)
    }

}
