//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

protocol FSProductInCartCellDelegate: class {
    func updateTotalPrice()
}

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

    private lazy var totalPriceLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Итого:"

        return label
    }()

    private lazy var totalPrice: FSLabel = {
        let label = FSLabel()

        return label
    }()

    private lazy var totalPriceCurrency: FSLabel = {
        let label = FSLabel()
        label.text = "руб."

        return label
    }()

    private lazy var totalPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(totalPriceLabel)
        stackView.addSubview(totalPrice)
        stackView.addSubview(totalPriceCurrency)

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.cartLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.totalPriceStackView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.reloadData()
        self.calculateTotalPrice()
    }

    override func updateViewConstraints() {
        self.cartLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cartLabel.snp.bottom)
            make.left.right.equalToSuperview()
//            make.height.equalTo(self.view.bounds.height / 7 * 3)
        }

        self.totalPriceStackView.snp.makeConstraints { (make) in
            make.top.lessThanOrEqualTo(self.tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.totalPriceLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.totalPrice.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.totalPriceLabel.snp.right)
        }

        self.totalPriceCurrency.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.totalPrice.snp.right)
        }

        super.updateViewConstraints()
    }

    func addProductToCart(with product: FSProduct, and quantity: Int) {

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

    func calculateTotalPrice() {
        var totalPrice: Double = 0
        for item in self.productsInCart {
            totalPrice += item.product.price * Double(item.quantity)
        }
        self.totalPrice.text = String(totalPrice)
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
        cell.delegate = self

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

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.bounds.height / 5
//    }
}

extension FSCartController: FSProductInCartCellDelegate {
    func updateTotalPrice() {

    }
}
