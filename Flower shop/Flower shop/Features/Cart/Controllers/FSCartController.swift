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

    private lazy var courierDeliveryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.paymentMethodStackView)
        stackView.addSubview(self.phoneNumberTextField)
        stackView.addSubview(self.deliveryAddressTextField)

        return stackView
    }()

    private lazy var takeawayShopsRadioGroup: ALRadioGroup = {
        let firstShop = ALRadioItem(title: "Магазин 1, ул. Хамицевича 3", subtitle: "ст.м. Тракторный завод")
        let secondShop = ALRadioItem(title: "Магазин 2, ул. Евгения 2", subtitle: "ст.м. Московская")
        let thirdShop = ALRadioItem(title: "Магазин 3, ул. Михайловича 1", subtitle: "ст.м. Зелёный луг")
        let radioGroup = ALRadioGroup(items: [firstShop, secondShop, thirdShop], style: .standard)
        radioGroup.selectedIndex = 0
        radioGroup.addTarget(self, action: #selector(radioGroupSelected(_:)), for: .valueChanged)
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

    private lazy var takeawayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.takeawayShopsRadioGroup)
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
        self.view.addSubview(self.cartLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.totalPriceStackView)
        self.view.addSubview(self.deliveryMethodSegmentedControlView)
        self.view.addSubview(self.courierDeliveryStackView)
        self.view.addSubview(self.takeawayStackView)
        self.view.addSubview(self.checkoutButton)
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
            make.height.equalTo(35)
        }

        self.takeawayStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deliveryMethodSegmentedControlView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.takeawayShopsRadioGroup.snp.makeConstraints { (make) in
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
            make.top.equalTo(self.takeawayStackView.snp.bottom)
            make.left.right.equalToSuperview().inset(45)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(40)
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

    @objc private func viewDidTapped() {
        self.view.endEditing(true)
    }

    @objc private func radioGroupSelected(_ sender: ALRadioGroup) {
        //        print(sender.selectedIndex)
    }

    @objc private func checkoutButtonDidTap() {
        self.checkCheckoutErrors()
        let hasErrors = self.checkCheckoutErrors()
        if !hasErrors {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    @objc private func segmentedControlChangeValue(sender: FSSegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.deliveryMethodSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.deliveryMethodSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.courierDeliveryStackView.alpha = 1
            self.takeawayStackView.alpha = 0

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
            self.takeawayStackView.alpha = 1

            self.checkoutButton.snp.remakeConstraints { (make) in
                make.top.equalTo(self.takeawayStackView.snp.bottom)
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
        }

        if let phone = self.phoneNumberTextField.text,
           let address = self.deliveryAddressTextField.text,
           self.deliveryMethodSegmentedControlView.segmentedControl.selectedSegmentIndex == 0 {
            if phone.isEmpty {
                errors = true
                message += "Введите номер телефона"
                alertWithTitle(title: title, message: message, toFocus: self.phoneNumberTextField)
            } else if phone.count < 17 {
                errors = true
                message += "Неправильный номер телефона"
                alertWithTitle(title: title, message: message, toFocus: self.phoneNumberTextField)
            } else if address.isEmpty {
                errors = true
                message += "Введите адрес доставки"
                alertWithTitle(title: title, message: message, toFocus: self.deliveryAddressTextField)
            }
        }

        return errors
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

        return cell
    }
}

extension FSCartController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

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

extension FSCartController: FSProductInCartCellDelegate {
    func updateTotalPrice() {

    }
}

extension FSCartController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField {
        case self.phoneNumberTextField:
            guard let text = textField.text, text.isEmpty else { return true }
            textField.text = "8 (0"
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
