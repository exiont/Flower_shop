//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: FSViewController {

    var products: [FSProduct] = []
    var counters: [Int] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
    }

    func updateProductList(with product: FSProduct, and counter: Int) {
        products.append(product)
        self.counters.append(counter)
    }
}
