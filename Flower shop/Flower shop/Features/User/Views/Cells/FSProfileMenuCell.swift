//
//  FSProfileMenuCell.swift
//  Flower shop
//
//  Created by New on 14.04.21.
//

import UIKit

class FSProfileMenuCell: UITableViewCell {

    static let reuseIdentifier: String = "FSProfileMenuCell"

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()

    private lazy var menuIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = FSColors.mainPink
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var menuTitle: FSLabel = {
        let label = FSLabel()

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
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.menuIcon)
        self.containerView.addSubview(self.menuTitle)
        self.updateConstraints()
    }

    func setCell(image: UIImage, title: String) {
        self.menuIcon.image = image
        self.menuTitle.text = title

        self.setNeedsUpdateConstraints()
    }

    override func updateConstraints() {

        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.menuIcon.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview()
            make.width.equalTo(self.menuIcon.snp.height)
        }

        self.menuTitle.snp.updateConstraints { (make) in
            make.left.equalTo(self.menuIcon.snp.right).offset(5)
            make.centerY.equalTo(self.menuIcon)
            make.right.greaterThanOrEqualToSuperview()
        }

        super.updateConstraints()
    }

}
