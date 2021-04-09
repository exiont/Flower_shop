//
//  FSProductViewController.swift
//  Flower shop
//
//  Created by New on 29.03.21.
//

import UIKit

class FSProductViewController: FSViewController {

    var product: FSProduct? = nil

    let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_placeholder")
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
        label.textColor = FSColors.brownRed
        return label
    }()

    private lazy var productDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed

        return label
    }()

    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed
        label.text = "Стоимость:"

        return label
    }()

    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.textColor = FSColors.brownRed

        return label
    }()

    private lazy var productPriceCurrency: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.textColor = FSColors.brownRed
        label.text = "руб."

        return label
    }()

    private lazy var productIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed
        label.text = "Артикул:"

        return label
    }()

    private lazy var productId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed

        return label
    }()

    private lazy var productDetailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed
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

    private lazy var addToCartButton: FSButton = {
        let button = FSButton()
        button.setTitle("Добавить в корзину", for: .normal)
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
        self.mainView.addSubview(self.productDetailsLabel)
        self.mainView.addSubview(self.productDetails)
        self.mainView.addSubview(self.addToCartButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func updateViewConstraints() {

        self.productImageView.snp.updateConstraints { (make) in
//            let aspectRatio = UIScreen.main.bounds.width / UIScreen.main.bounds.height
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
//            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
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
            make.left.right.equalToSuperview().inset(self.edgeInsets)
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

        self.addToCartButton.snp.updateConstraints { (make) in
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
        self.productImageView.image = product.image != nil
            ? product.image
            : UIImage(named: "flower_placeholder")
        self.productId.text = product.id
        self.productPrice.text = String(product.price)
        self.productName.text = product.name
        self.productDescription.text = product.description
        self.productDetails.text = product.details

    }

    @objc func addToCartButtonDidTap() {

       guard let navVC = tabBarController?.viewControllers![1] as? UINavigationController,
             let cartTableViewController = navVC.topViewController as? FSCartController else { return }
        if let product = self.product {
            cartTableViewController.updateProductList(with: product)
        }
//        guard let vc = FSTabBarController().viewControllers?[1] as? FSCartController else { return }
//        if let product = self.product {
//            vc.products.append(product)
//        }
    }

}
