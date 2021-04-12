//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: FSViewController {

    var productsInCart: [FSProductInCart] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
    }

    func updateProductList(with product: FSProduct, and quantity: Int) {

        if productsInCart.filter({ $0.product.id == product.id }).count == 0 {
            let addedProduct = FSProductInCart(product: product, quantity: quantity)
            productsInCart.append(addedProduct)
        } else {
            for (index, item) in productsInCart.enumerated() {
                if item.product.id == product.id {
                    productsInCart[index].quantity += quantity
                }
            }
        }
    }
}
