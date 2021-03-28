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
        return view
    }()

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_placeholder")
//        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.frame.size.height = 30
        imageView.layer.cornerRadius = imageView.bounds.height / 2
//        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private lazy var productDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black

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
        self.productImageView.layer.cornerRadius = self.productImageView.bounds.height / 2
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
            make.size.equalTo(80)
        }

        self.productName.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(5)
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
