//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: FSViewController {

    var productsInCart: [FSProductInCart] = []

    private lazy var cartLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Корзина"
        label.textAlignment = .center
        label.font = UIFont.applyCustomFont(name: "Caveat-Regular", size: 30)

        return label
    }()

    private lazy var tableView: FSTableView = {
        let tableView = FSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSProductInCartCell.self, forCellReuseIdentifier: FSProductInCartCell.reuseIdentifier)

        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.cartLabel)
        self.view.addSubview(self.tableView)
    }

    override func updateViewConstraints() {
        self.cartLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateViewConstraints()
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

extension FSCartController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductInCartCell.reuseIdentifier, for: indexPath) as? FSProductInCartCell,
              let placeholderImage = UIImage(named: "flower_placeholder") else { fatalError("No cell with this identifier") }

        let addedProduct = self.productsInCart[indexPath.row]
        cell.setCell(image: addedProduct.product.image ?? placeholderImage,
                     name: addedProduct.product.name,
                     price: addedProduct.product.price,
                     quantity: addedProduct.quantity)

        return cell
    }
}

extension FSCartController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = FSProductViewController()
//        let product = products[indexPath.row]
//        vc.loadData(product: product)
//        navigationController?.pushViewController(vc, animated: true)

//        let navVC = UINavigationController(rootViewController: vc)
//        self.present(navVC, animated: true, completion: nil)
    }
}
