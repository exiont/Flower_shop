//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit
import ALRadioButtons
import FirebaseAuth
import FirebaseFirestore

class FSCartController: FSViewController, FSProductInCartCellDelegate {

    var productsInCart: [FSProductInCart] = []
    private var isСourierDelivery: Bool = true

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
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        return label
    }()

    private lazy var totalPrice: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    private lazy var totalPriceCurrency: FSLabel = {
        let label = FSLabel()
        label.text = "руб."
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        return label
    }()

    private lazy var totalPriceSeparatorView: FSSeparatorView = {
        let view = FSSeparatorView()

        return view
    }()

    private lazy var totalPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(totalPriceSeparatorView)
        stackView.addSubview(totalPriceLabel)
        stackView.addSubview(totalPrice)
        stackView.addSubview(totalPriceCurrency)

        return stackView
    }()

    private lazy var deliveryMethodSegmentedControlView: FSSegmentedControlView = {
        let view = FSSegmentedControlView()
        view.segmentedControl.insertSegment(withTitle: "Доставка", at: 0, animated: false)
        view.segmentedControl.insertSegment(withTitle: "Самовывоз", at: 1, animated: false)
        view.segmentedControl.selectedSegmentIndex = 0
        view.segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeValue(sender:)), for: .valueChanged)

        return view
    }()

    private lazy var phoneNumberTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Номер телефона"
        textField.leftView = UIImageView(image: UIImage(systemName: "phone.circle.fill"))
        textField.keyboardType = .phonePad
        textField.smartInsertDeleteType = .no
        textField.delegate = self

        return textField
    }()

    private lazy var deliveryAddressTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Адрес доставки"
        textField.leftView = UIImageView(image: UIImage(systemName: "house.circle.fill"))
        textField.delegate = self
        textField.autocorrectionType = .no

        return textField
    }()

    private lazy var paymentMethodLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Способ оплаты:"

        return label
    }()

    private lazy var paymentMethodRadioGroup: ALRadioGroup = {
        let radioGroup = ALRadioGroup(items: [.init(title: "Наличными"), .init(title: "Картой")], style: .standard)
        radioGroup.selectedIndex = 0
        radioGroup.addTarget(self, action: #selector(paymentMethodSelected(_:)), for: .valueChanged)
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

    private lazy var courierDeliveryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.paymentMethodStackView)
        stackView.addSubview(self.phoneNumberTextField)
        stackView.addSubview(self.deliveryAddressTextField)

        return stackView
    }()

    private lazy var pickupPointsRadioGroup: ALRadioGroup = {
        let firstShop = ALRadioItem(title: "Магазин 1, ул. Хамицевича 3", subtitle: "ст.м. Тракторный завод, 10:00 - 21:00")
        let secondShop = ALRadioItem(title: "Магазин 2, ул. Евгения 2", subtitle: "ст.м. Московская, 8:00 - 00:00")
        let thirdShop = ALRadioItem(title: "Магазин 3, ул. Михайловича 1", subtitle: "ст.м. Зелёный луг, 9:00 - 22:00")
        let radioGroup = ALRadioGroup(items: [firstShop, secondShop, thirdShop], style: .standard)
        radioGroup.selectedIndex = 0
        radioGroup.addTarget(self, action: #selector(pickupPointSelected(_:)), for: .valueChanged)
        radioGroup.axis = .vertical
        radioGroup.unselectedTitleColor = FSColors.brownRed
        radioGroup.selectedTitleColor = FSColors.mainPink
        radioGroup.unselectedIndicatorColor = FSColors.brownRed
        radioGroup.selectedIndicatorColor = FSColors.mainPink
        radioGroup.subtitleColor = .gray
        radioGroup.indicatorRingWidth = 1
        radioGroup.separatorColor = .clear

        return radioGroup
    }()

    private lazy var pickupPointsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.pickupPointsRadioGroup)
        stackView.alpha = 0

        return stackView
    }()

    private lazy var checkoutButton: FSButton = {
        let button = FSButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.addTarget(self, action: #selector(checkoutButtonDidTap), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTapped)))

        addSubviews()
        loadUserAddress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.reloadData()
        self.calculateTotalPrice()
        self.updateViewConstraints()
    }

    func addSubviews() {
        self.view.addSubview(self.cartLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.totalPriceStackView)
        self.view.addSubview(self.deliveryMethodSegmentedControlView)
        self.view.addSubview(self.courierDeliveryStackView)
        self.view.addSubview(self.pickupPointsStackView)
        self.view.addSubview(self.checkoutButton)
    }

    private func loadUserAddress() {
        guard let user = Auth.auth().currentUser else { return }
        let addresses = Firestore.firestore().collection("addresses")
        let userAddress = addresses.document(user.uid)
        userAddress.addSnapshotListener(includeMetadataChanges: true) { (addressSnapshot, error) in
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let address = addressSnapshot {
                self.deliveryAddressTextField.text = address.get("address") as? String
            }
        }
    }

    private func formOrder() -> FSOrder {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)

        let totalPrice: Double = self.calculateTotalPrice()
        let address: String = self.deliveryAddressTextField.text ?? ""
        let phoneNumber: String = self.phoneNumberTextField.text ?? ""
        let paymentMethod: String = paymentMethodSelected(self.paymentMethodRadioGroup) ? "Cash" : "Card"
        let pickupPoint = pickupPointSelected(self.pickupPointsRadioGroup)
        var orderProducts: [String: Int] = [:]

        self.productsInCart.forEach { orderProducts.updateValue($0.quantity, forKey: String($0.product.id)) }

        if isСourierDelivery {
            let order = FSOrder(isСourierDelivery: isСourierDelivery,
                                orderProducts: orderProducts,
                                totalPrice: totalPrice,
                                address: address,
                                phoneNumber: phoneNumber,
                                paymentMethod: paymentMethod,
                                date: dateString)

            return order
        } else {
            let order = FSOrder(isСourierDelivery: isСourierDelivery,
                                orderProducts: orderProducts,
                                totalPrice: totalPrice,
                                phoneNumber: phoneNumber,
                                pickupPoint: pickupPoint,
                                date: dateString)

            return order
        }
    }

    private func sendOrder() {
        let newOrder = self.formOrder()
        guard let user = Auth.auth().currentUser else { return }
        let orders = Firestore.firestore().collection("orders")
        let userOrders = orders.document(user.uid)
        let orderData: [String: Any] = [newOrder.date: ["date": newOrder.date,
                                                        "totalPrice": newOrder.totalPrice,
                                                        "phoneNumber": newOrder.phoneNumber,
                                                        "address": newOrder.address,
                                                        "paymentMethod": newOrder.paymentMethod,
                                                        "pickupPoint": newOrder.pickupPoint,
                                                        "isСourierDelivery": newOrder.isСourierDelivery,
                                                        "orderedProducts": newOrder.orderedProducts]]

        userOrders.setData(orderData, merge: true) { error in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Ошибка")
            } else {
                self.showAlert(message: "Заказ оформлен", title: "")
            }
        }
    }

    func addProductToCart(with product: FSProduct?, and quantity: Int) {
        guard let product = product else { return }
        if productsInCart.filter({ $0.product.id == product.id }).count == 0 {
            let addedProduct = FSProductInCart(product: product, quantity: quantity)
            productsInCart.append(addedProduct)
        } else {
            for (index, item) in productsInCart.enumerated() {
                if item.product.id == product.id {
                    if (item.quantity + quantity) < 500 {
                    productsInCart[index].quantity += quantity
                    } else {
                        productsInCart[index].quantity = 500
                        showAlert(message: "Для приобритения более 500 единиц товара свяжитесь с отделом продаж", title: "")
                    }
                }
            }
        }
    }

    @discardableResult func calculateTotalPrice() -> Double {
        var totalPrice: Double = 0
        for item in self.productsInCart {
            totalPrice += item.product.price * Double(item.quantity)
        }
        if let navVC = self.tabBarController?.viewControllers?[3] as? UINavigationController,
           let profile = navVC.topViewController as? FSProfileController {
            let discount = profile.getDiscount()
            totalPrice -= totalPrice * Double(discount) / 100
        }
        let roundedPrice = round(totalPrice * 100) / 100
        self.totalPrice.text = String(roundedPrice)
        return roundedPrice
    }

    @objc private func viewDidTapped() {
        self.view.endEditing(true)
    }

    @objc private func paymentMethodSelected(_ sender: ALRadioGroup) -> Bool {
        sender.selectedIndex == 0
    }

    @objc private func pickupPointSelected(_ sender: ALRadioGroup) -> Int {
        sender.selectedIndex + 1
    }

    @objc private func checkoutButtonDidTap() {
        self.checkCheckoutErrors()
        let hasErrors = self.checkCheckoutErrors()
        if !hasErrors {
            self.sendOrder()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    @objc private func segmentedControlChangeValue(sender: FSSegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.deliveryMethodSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.deliveryMethodSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.courierDeliveryStackView.alpha = 1
            self.pickupPointsStackView.alpha = 0
            self.isСourierDelivery.toggle()
            self.view.endEditing(true)

            self.checkoutButton.snp.remakeConstraints { (make) in
                make.top.equalTo(self.courierDeliveryStackView.snp.bottom).offset(20)
                make.left.right.equalToSuperview().inset(45)
                make.bottom.lessThanOrEqualToSuperview()
                make.height.equalTo(40)
            }
        case 1:
            self.deliveryMethodSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.deliveryMethodSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.courierDeliveryStackView.alpha = 0
            self.pickupPointsStackView.alpha = 1
            self.isСourierDelivery.toggle()
            self.view.endEditing(true)

            self.checkoutButton.snp.remakeConstraints { (make) in
                make.top.equalTo(self.pickupPointsStackView.snp.bottom)
                make.left.right.equalToSuperview().inset(45)
                make.bottom.lessThanOrEqualToSuperview()
                make.height.equalTo(40)
            }
        default:
            break
        }
    }

    @discardableResult
    func checkCheckoutErrors() -> Bool {

        let title = "Ошибка"
        var message = ""
        var errors = false

        if productsInCart.count < 1 {
            errors = true
            message += "В корзине нет товаров"
            showAlert(message: message, title: title)
        } else if let phone = self.phoneNumberTextField.text, phone.isEmpty {
            errors = true
            message += "Введите номер телефона"
            showAlert(message: message, title: title)
        } else if let phone = self.phoneNumberTextField.text, phone.count < 17 {
            errors = true
            message += "Неправильный номер телефона"
            showAlert(message: message, title: title)
        }

        if let address = self.deliveryAddressTextField.text, self.isСourierDelivery {
            if address.isEmpty {
                errors = true
                message += "Введите адрес доставки"
                alertWithTitle(title: title, message: message, toFocus: self.deliveryAddressTextField)
            }
        }

        return errors
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
                make.height.equalTo(60)
            case 2:
                make.height.equalTo(120)
            default:
                make.height.equalTo(180)
            }
        }

        self.totalPriceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(10)
        }

        self.totalPriceSeparatorView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        self.totalPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalPriceSeparatorView.snp.bottom).offset(5)
            make.left.bottom.equalToSuperview()
        }

        self.totalPrice.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalPriceSeparatorView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.equalTo(self.totalPriceLabel.snp.right).offset(5)
        }

        self.totalPriceCurrency.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalPriceSeparatorView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.equalTo(self.totalPrice.snp.right).offset(2)
            make.right.lessThanOrEqualToSuperview()
        }

        self.deliveryMethodSegmentedControlView.snp.makeConstraints { (make) in
            make.top.equalTo(self.totalPriceStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }

        self.pickupPointsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryMethodSegmentedControlView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.pickupPointsRadioGroup.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }

        self.courierDeliveryStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryMethodSegmentedControlView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.paymentMethodStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
        }

        self.paymentMethodLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.paymentMethodRadioGroup.snp.makeConstraints { (make) in
            make.top.equalTo(self.paymentMethodLabel.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }

        self.phoneNumberTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.paymentMethodStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(15)
        }

        self.deliveryAddressTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneNumberTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }

        self.checkoutButton.snp.remakeConstraints { (make) in
            make.top.equalTo(self.pickupPointsStackView.snp.bottom)
            make.left.right.equalToSuperview().inset(45)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(40)
        }

        super.updateViewConstraints()
    }
}

extension FSCartController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productsInCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductInCartCell.reuseIdentifier, for: indexPath) as? FSProductInCartCell,
              let placeholderImage = UIImage(named: "flower_placeholder") else { return UITableViewCell() }

        let addedProduct = self.productsInCart[indexPath.row]
        cell.setCell(image: addedProduct.product.image ?? placeholderImage,
                     name: addedProduct.product.name,
                     price: addedProduct.product.price,
                     quantity: addedProduct.quantity)
        cell.delegate = self
        cell.product = addedProduct.product

        return cell
    }
}

extension FSCartController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.productsInCart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateViewConstraints()
        }
        self.calculateTotalPrice()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FSCartController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField {
        case self.phoneNumberTextField:
            guard let text = textField.text, text.isEmpty else { return true }
            textField.text = "8 (0"
            let end = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: end, to: end)
        default: return true
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        switch textField {
        case self.phoneNumberTextField:
            guard let text = textField.text,
                  let rangeOfTextToReplace = Range(range, in: text) else { return true }
            let formattedText = text.applyPatternOnNumbers(pattern: "# (###) ###-##-##", replacmentCharacter: "#")
            let substringToReplace = text[rangeOfTextToReplace]
            let count = text.count - substringToReplace.count + string.count
            textField.text = formattedText
            return count <= 17
        default: return true
        }
    }
}
