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
        imageView.image = UIImage(named: "flower_placeholder")
        imageView.clipsToBounds = false
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

    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "PRICE" // temp

        return label
    }()

    private lazy var productId: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "ID" // temp

        return label
    }()

    private lazy var productDetails: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "brown_red")
        label.text = "DETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDETAILSDE" // temp

        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("ADD", for: .normal)
        button.addTarget(self, action: #selector(addToCartButtonDidTap), for: .touchUpInside)

        return button
    }()

    override func initController() {
        super.initController()

        self.mainView.addSubview(self.productImageView)
        self.mainView.addSubview(self.productName)
        self.mainView.addSubview(self.productDescription)
        self.mainView.addSubview(self.productPrice)
        self.mainView.addSubview(self.productId)
        self.mainView.addSubview(self.productDetails)
        self.mainView.addSubview(self.addToCartButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func updateViewConstraints() {

        self.productImageView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(10)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.productId.snp.updateConstraints { (make) in
            make.top.equalTo(self.productImageView.snp.bottom).offset(10)
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(self.productName.snp.right).offset(20)
        }

        self.productDescription.snp.updateConstraints { (make) in
            make.top.equalTo(self.productName.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.productPrice.snp.updateConstraints { (make) in
            make.top.equalTo(self.productDescription.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(10)
        }

        self.addToCartButton.snp.updateConstraints { (make) in
            make.top.equalTo(self.productPrice)
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(self.productPrice.snp.right).offset(20)
            make.width.greaterThanOrEqualTo(50)
        }

        self.productDetails.snp.updateConstraints { (make) in
            make.top.equalTo(self.addToCartButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
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
