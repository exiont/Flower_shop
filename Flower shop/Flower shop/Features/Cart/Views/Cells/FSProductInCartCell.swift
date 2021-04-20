//
//  FSProductInCartCell.swift
//  Flower shop
//
//  Created by New on 12.04.21.
//

import UIKit

protocol FSProductInCartCellDelegate: class {
    func addProductToCart(with product: FSProduct?, and quantity: Int)
    func calculateTotalPrice() -> Double
}

class FSProductInCartCell: UITableViewCell {

    static let reuseIdentifier: String = "FSProductInCartCell"

    weak var delegate: FSProductInCartCellDelegate?
    var product: FSProduct?

    let boldCounterButtonTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.mainPink,
                                                                          .font: UIFont.systemFont(ofSize: 30, weight: .heavy)]

    private var timer: Timer?

    private lazy var counter: Int = 0

    private let productImageSize: CGSize = CGSize(width: 50, height: 50)

    private lazy var productContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = FSColors.mainPink.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)

        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_placeholder")
        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = self.frame.height / 2
        imageView.layer.cornerRadius = self.productImageSize.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private lazy var productName: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    private lazy var productPrice: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)

        return label
    }()

    private lazy var productPriceCurrency: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "руб."

        return label
    }()

    private lazy var productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.productPrice)
        stackView.addSubview(self.productPriceCurrency)
//        stackView.contentMode = .left

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
        self.productContainerView.addSubview(self.productPriceStackView)
        self.productContainerView.addSubview(self.productQuantityStackView)
    }

    override func updateConstraints() {
        self.productContainerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.productImageView.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(5)
            make.size.equalTo(self.productImageSize)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalTo(self.productImageView.snp.right).offset(10)
            make.right.greaterThanOrEqualTo(self.productQuantityStackView.snp.left)
        }

        self.productPriceStackView.snp.updateConstraints { (make) in
            make.top.equalTo(self.productName.snp.bottom).offset(5)
            make.left.equalTo(self.productName)
            make.right.greaterThanOrEqualTo(self.productQuantityStackView.snp.left)
            make.bottom.lessThanOrEqualToSuperview()
        }

        self.productPrice.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.right.equalTo(self.productPriceCurrency.snp.left).offset(-5)
        }

        self.productPriceCurrency.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        self.productQuantityStackView.snp.updateConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(105)
        }

        self.addProductItemButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }

        self.productCurrentQuantity.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.addProductItemButton.snp.right)
            make.width.equalTo(45)
        }

        self.removeProductItemButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.productCurrentQuantity.snp.right)
        }

        super.updateConstraints()
    }

    func setCell(image: UIImage, name: String, price: Double, quantity: Int) {
        self.productImageView.image = image
        self.productName.text = name
        self.productPrice.text = String(price)
        self.productCurrentQuantity.text = String(quantity)

        self.setNeedsUpdateConstraints()
    }

    @objc func addProductItemButtonDidTap() {
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        if currentQuantity < 500 {
            var newQuantity = currentQuantity
            newQuantity += 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
            delegate?.addProductToCart(with: self.product, and: 1)
            delegate?.calculateTotalPrice()
        }
    }

    @objc func removeProductItemButtonDidTap() {
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        if currentQuantity > 1 {
            var newQuantity = currentQuantity
            newQuantity -= 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
            delegate?.addProductToCart(with: self.product, and: -1)
            delegate?.calculateTotalPrice()
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
