//
//  FSProductViewController.swift
//  Flower shop
//
//  Created by New on 29.03.21.
//

import UIKit

class FSProductViewController: FSViewController {

    var product: Product? = nil

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "flower_placeholder") {
            imageView.image = image
        }
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "brown_red")
        return label
    }()

    private lazy var productDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")

        return label
    }()

    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "Стоимость:"

        return label
    }()

    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.textColor = UIColor(named: "brown_red")
        label.text = "5 руб." // temp

        return label
    }()

    private lazy var productIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "Артикул:"

        return label
    }()

    private lazy var productId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "000" // temp

        return label
    }()

    private lazy var productDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "Описание:"

        return label
    }()

    private lazy var productDetails: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(named: "brown_red")
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        let additionalText = "Для вашей избранницы, подруги, мамы или коллеги! "
        textView.text = additionalText + "Этот весенний букет принесет свежесть и радостное настроение получателю, будет долго стоять в вазе и радовать своими яркими красками. Наш магазин и курьерская служба доставят получателю вместе с вашим подарком только положительные эмоции." // temp

        return textView
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Добавить в корзину", for: .normal)
        button.addTarget(self, action: #selector(addToCartButtonDidTap), for: .touchUpInside)

        return button
    }()

    override func initController() {
        super.initController()
        self.setContentScrolling(isEnabled: false)

        self.mainView.addSubview(self.productImageView)
        self.mainView.addSubview(self.productName)
        self.mainView.addSubview(self.productDescription)
        self.mainView.addSubview(self.productPriceLabel)
        self.mainView.addSubview(self.productPrice)
        self.mainView.addSubview(self.productIdLabel)
        self.mainView.addSubview(self.productId)
        self.mainView.addSubview(self.productDetailsLabel)
        self.mainView.addSubview(self.productDetails)
        self.mainView.addSubview(self.addToCartButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func updateViewConstraints() {

        self.productImageView.snp.updateConstraints { (make) in
//            let aspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2.5)

        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.productIdLabel.snp.updateConstraints { (make) in
//            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
            make.centerY.equalTo(self.productName)
            make.left.equalTo(self.productName.snp.right).offset(20)
        }

        self.productId.snp.updateConstraints { (make) in
//            make.top.equalTo(self.productIdLabel)
            make.centerY.equalTo(self.productName)
            make.left.equalTo(self.productIdLabel.snp.right).offset(5)
            make.right.equalToSuperview().inset(10)
        }

        self.productDescription.snp.updateConstraints { (make) in
            make.top.equalTo(self.productName.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(10)
        }

        self.productPriceLabel.snp.updateConstraints { (make) in
//            make.top.equalTo(self.productDescription.snp.bottom).offset(10)
            make.top.equalTo(self.productDescription.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(10)
        }

        self.productPrice.snp.updateConstraints { (make) in
//            make.bottom.equalTo(self.productPriceLabel)
            make.left.equalTo(self.productPriceLabel.snp.right).offset(10)
            make.centerY.equalTo(self.productPriceLabel)
        }

        self.addToCartButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.productPriceLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(10)
        }

        self.productDetailsLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.addToCartButton.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.productDetails.snp.updateConstraints { (make) in
            make.top.equalTo(self.productDetailsLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }

        super.updateViewConstraints()

    }

    func loadData(product: Product) {
        self.product = product
        if product.image != nil {
            self.productImageView.image = product.image
        } else {
            self.productImageView.image = UIImage(named: "flower_placeholder")
        }
        self.productName.text = product.name
        self.productDescription.text = product.description
    }

    @objc func addToCartButtonDidTap() {
//        guard let vc = FSTabBarController().viewControllers?[1] as? FSCartController else { return }
//        if let product = self.product {
//            vc.products.append(product)
//        }
    }

}
