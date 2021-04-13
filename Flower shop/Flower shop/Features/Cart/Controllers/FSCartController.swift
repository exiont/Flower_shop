//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit
import ALRadioButtons

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

    private lazy var deliveryMethodSegmentedControlView: FSSegmentedControlView = {
        let view = FSSegmentedControlView()
        view.segmentedControl.insertSegment(withTitle: "Доставка", at: 0, animated: true)
        view.segmentedControl.insertSegment(withTitle: "Самовывоз", at: 1, animated: true)
        view.segmentedControl.selectedSegmentIndex = 0
        view.segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeValue(sender:)), for: .valueChanged)
        return view
    }()

    private lazy var paymentMethodLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Способ оплаты:"

        return label
    }()

    private lazy var paymentMethodRadioGroup: ALRadioGroup = {
        let radioGroup = ALRadioGroup(items: [.init(title: "Наличными"), .init(title: "Картой")], style: .standard)
        radioGroup.selectedIndex = 0
        radioGroup.addTarget(self, action: #selector(radioGroupSelected(_:)), for: .valueChanged)
        radioGroup.axis = .horizontal
        radioGroup.unselectedTitleColor = FSColors.brownRed
        radioGroup.selectedTitleColor = FSColors.mainPink
        radioGroup.unselectedIndicatorColor = FSColors.brownRed
        radioGroup.selectedIndicatorColor = FSColors.mainPink
        radioGroup.indicatorRingWidth = 1
        radioGroup.separatorColor = .clear

        return radioGroup
    }()

    private lazy var paymentMethodStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(paymentMethodLabel)
        stackView.addSubview(paymentMethodRadioGroup)

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.cartLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.totalPriceStackView)
        self.view.addSubview(self.deliveryMethodSegmentedControlView)
        self.view.addSubview(self.paymentMethodStackView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.reloadData()
        self.calculateTotalPrice()
        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        self.cartLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.updateConstraints { (make) in
            make.top.equalTo(self.cartLabel.snp.bottom)
            make.left.right.equalToSuperview()
            switch self.productsInCart.count {
            case 0:
                make.height.equalTo(0)
            case 1:
                make.height.equalTo(80)
            case 2:
                make.height.equalTo(160)
            default:
                make.height.equalTo(240)
            }
        }

        self.totalPriceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }

        self.totalPriceLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.totalPrice.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.totalPriceLabel.snp.right).offset(5)
        }

        self.totalPriceCurrency.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.totalPrice.snp.right).offset(2)
            make.right.lessThanOrEqualToSuperview()
        }

        self.deliveryMethodSegmentedControlView.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalPriceStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        self.paymentMethodStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryMethodSegmentedControlView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        self.paymentMethodLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.paymentMethodRadioGroup.snp.makeConstraints { (make) in
            make.top.equalTo(self.paymentMethodLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
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

    @objc private func radioGroupSelected(_ sender: ALRadioGroup) {
//        print(sender.selectedIndex)
    }

    @objc private func segmentedControlChangeValue(sender: FSSegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.deliveryMethodSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.deliveryMethodSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
        case 1:
            self.deliveryMethodSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.deliveryMethodSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
        default:
            break
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FSCartController: FSProductInCartCellDelegate {
    func updateTotalPrice() {

    }
}
