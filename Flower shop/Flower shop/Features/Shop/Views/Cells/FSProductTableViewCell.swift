//
//  FSProductTableViewCell.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/28/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class FSProductTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "FSProductTableViewCell"

    private let productImageSize: CGSize = CGSize(width: 60, height: 60)

    private lazy var productContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = FSColors.mainPink.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_placeholder")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.productImageSize.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private lazy var productName: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)

        return label
    }()

    private lazy var productDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = FSColors.brownRed

        return label
    }()

    private lazy var productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = FSColors.brownRed

        return label
    }()

    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = FSColors.brownRed
        label.text = "руб."

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.initCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell() {
        self.contentView.addSubview(self.productContainerView)
        self.productContainerView.addSubview(self.productImageView)
        self.productContainerView.addSubview(self.productName)
        self.productContainerView.addSubview(self.productDescription)
        self.productContainerView.addSubview(self.productPrice)
        self.productContainerView.addSubview(self.productPriceLabel)
        self.selectionStyle = .none
    }

    override func updateConstraints() {

        self.productContainerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.productImageView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(self.productImageSize)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.productImageView.snp.right).offset(10)
        }

        self.productDescription.snp.updateConstraints { (make) in
            make.top.equalTo(self.productName.snp.bottom).offset(10)
            make.left.equalTo(self.productImageView.snp.right).offset(10)
            make.right.equalTo(self.productName)
        }

        self.productPrice.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(self.productPriceLabel.snp.left).offset(-5)
        }

        self.productPriceLabel.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(self.productPrice)
            make.right.equalToSuperview().inset(15)
        }

        super.updateConstraints()
    }

    func setCellFromDB(productQuery: QueryDocumentSnapshot) {
        let product = FSProduct.parseProduct(productQuery: productQuery)

        self.productImageView.image = UIImage(named: "flower_placeholder")
        self.productName.text = product.name
        self.productDescription.text = product.description
        self.productPrice.text = String(product.price)

        self.loadImage(product: product)

        self.setNeedsUpdateConstraints()
    }

    func loadImage(product: FSProduct) {
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(product.imageUrl)
        self.productImageView.sd_setImage(with: reference)
    }

}
