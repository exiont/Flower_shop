//
//  FSProductTableViewCell.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/28/21.
//

import UIKit

class FSProductTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "FSProductTableViewCell"

    private lazy var productContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor(named: "main_pink")?.cgColor
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
//        imageView.
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        imageView.layer.borderWidth = 1
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
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func updateConstraints() {

        super.updateConstraints()

        self.productContainerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.productImageView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(70)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.productImageView.snp.right).offset(10)
        }

        self.productDescription.snp.updateConstraints { (make) in
            make.top.equalTo(self.productName.snp.bottom).offset(10)
            make.left.equalTo(self.productImageView.snp.right).offset(10)
        }
    }

    func setCell(image: UIImage, name: String, description: String) {
        self.productImageView.image = image
        self.productName.text = name
        self.productDescription.text = description

        self.setNeedsUpdateConstraints()
    }

}
