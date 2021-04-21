//
//  FSProductViewController.swift
//  Flower shop
//
//  Created by New on 29.03.21.
//

import UIKit

class FSProductViewController: FSViewController {

    var product: FSProduct? = nil
    var counter: Int = 1

    private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    private let boldCounterButtonTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.mainPink,
                                                                                  .font: UIFont.systemFont(ofSize: 30, weight: .heavy)]

    private var timer: Timer?

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_placeholder")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var productName: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var productDescription: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    private lazy var productPriceLabel: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Стоимость:"

        return label
    }()

    private lazy var productPrice: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)

        return label
    }()

    private lazy var productPriceCurrency: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.text = "руб."

        return label
    }()

    private lazy var productIdLabel: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Артикул:"

        return label
    }()

    private lazy var productId: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    private lazy var productDetailsLabel: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Описание:"

        return label
    }()

    private lazy var productDetails: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = FSColors.brownRed
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false

        return textView
    }()

    private lazy var nameIdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.productName)
        stackView.addSubview(self.productIdLabel)
        stackView.addSubview(self.productId)

        return stackView
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.productPriceLabel)
        stackView.addSubview(self.productPrice)
        stackView.addSubview(self.productPriceCurrency)

        return stackView
    }()

    private lazy var addProductItemButton: FSCounterButton = {
        let button = FSCounterButton()
        button.setAttributedTitle(NSAttributedString(string: "+", attributes: self.boldCounterButtonTitleAttribute), for: .normal)
        button.addTarget(self, action: #selector(addProductItemButtonDidTap), for: .touchUpInside)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.counterButtonLongPressHandler))
        button.addGestureRecognizer(longpress)

        return button
    }()

    private lazy var removeProductItemButton: FSCounterButton = {
        let button = FSCounterButton()
        button.setAttributedTitle(NSAttributedString(string: "–", attributes: self.boldCounterButtonTitleAttribute), for: .normal)
        button.addTarget(self, action: #selector(removeProductItemButtonDidTap), for: .touchUpInside)
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.counterButtonLongPressHandler))
        button.addGestureRecognizer(longpress)

        return button
    }()

    private lazy var productCurrentQuantity: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.text = "\(self.counter)"
        label.textAlignment = .center

        return label
    }()

    private lazy var productQuantityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.addProductItemButton)
        stackView.addSubview(self.removeProductItemButton)
        stackView.addSubview(self.productCurrentQuantity)

        return stackView
    }()

    private lazy var addToCartButton: FSButton = {
        let button = FSButton()
        button.setTitle("Добавить в корзину", for: .normal)
        button.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
        button.addTarget(self, action: #selector(addToCartButtonDidTap), for: .touchUpInside)

        return button
    }()

    override func initController() {
        super.initController()
        self.setContentScrolling(isEnabled: false)

        self.mainView.addSubview(self.productImageView)
        self.mainView.addSubview(self.nameIdStackView)
        self.mainView.addSubview(self.productDescription)
        self.mainView.addSubview(self.priceStackView)
        self.mainView.addSubview(self.productQuantityStackView)
        self.mainView.addSubview(self.productDetailsLabel)
        self.mainView.addSubview(self.productDetails)
        self.mainView.addSubview(self.addToCartButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

    override func updateViewConstraints() {

        self.productImageView.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2.5)
        }

        self.nameIdStackView.snp.updateConstraints { (make) in
            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(self.productIdLabel.snp.left)
        }

        self.productIdLabel.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(self.productId.snp.left).offset(-5)
        }

        self.productId.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }

        self.productDescription.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameIdStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.priceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.productDescription.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(self.edgeInsets)
        }

        self.productPriceLabel.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.productPrice.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.productPriceLabel.snp.right).offset(10)
        }

        self.productPriceCurrency.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.productPrice.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview()
        }

        self.productQuantityStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.productDescription.snp.bottom)
            make.left.greaterThanOrEqualTo(self.priceStackView.snp.right).offset(20)
            make.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalTo(self.addToCartButton.snp.top)
        }

        self.addProductItemButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.productCurrentQuantity.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.addProductItemButton.snp.right).offset(5)
            make.width.equalTo(45)
        }

        self.removeProductItemButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.productCurrentQuantity.snp.right).offset(5)
        }

        self.addToCartButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceStackView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.productDetailsLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.addToCartButton.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.productDetails.snp.updateConstraints { (make) in
            make.top.equalTo(self.productDetailsLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
        }

        super.updateViewConstraints()
    }

    func loadData(product: FSProduct) {
        self.product = product
        self.productImageView.image = product.image
        self.productId.text = String(product.id)
        self.productPrice.text = String(product.price)
        self.productName.text = product.name
        self.productDescription.text = product.description
        self.productDetails.text = product.details
    }

    @objc func addToCartButtonDidTap() {

       guard let navVC = tabBarController?.viewControllers![1] as? UINavigationController,
             let cartTableViewController = navVC.topViewController as? FSCartController else { return }
        if let product = self.product {
            cartTableViewController.addProductToCart(with: product, and: self.counter)
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func addProductItemButtonDidTap() {
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        if currentQuantity < 500 {
            var newQuantity = currentQuantity
            newQuantity += 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
        } else {
            self.timer?.invalidate()
            self.timer = nil
            self.showAlert(message: "Для приобритения более 500 единиц товара свяжитесь с отделом продаж", title: "")
        }
    }

    @objc func removeProductItemButtonDidTap() {
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        if currentQuantity > 1 {
        var newQuantity = currentQuantity
        newQuantity -= 1
        self.counter = newQuantity
        self.productCurrentQuantity.text = String(newQuantity)
        } else {
            self.timer?.invalidate()
            self.timer = nil
            self.showAlert(message: "Количество товара не может быть меньше 1", title: "")
        }
    }

    @objc func counterButtonLongPressHandler(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                if let button = sender.view as? FSCounterButton {
                    switch button {
                    case self.addProductItemButton:
                        self.addProductItemButtonDidTap()
                    case self.removeProductItemButton:
                        self.removeProductItemButtonDidTap()
                    default: break
                    }
                }
            })
        } else if sender.state == .ended || sender.state == .cancelled {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}
