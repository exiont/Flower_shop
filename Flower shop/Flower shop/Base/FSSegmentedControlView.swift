//
//  FSSegmentedControlView.swift
//  Flower shop
//
//  Created by New on 13.04.21.
//

import UIKit

class FSSegmentedControlView: UIView {

    lazy var segmentedControl: FSSegmentedControl = {
        let segmentedControl = FSSegmentedControl()

        return segmentedControl
    }()

    lazy var leftBottomUnderlineView: FSLineView = {
        let underlineView = FSLineView()

        return underlineView
    }()

    lazy var rightBottomUnderlineView: FSLineView = {
        let underlineView = FSLineView()
        underlineView.isHidden = true

        return underlineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(segmentedControl)
        self.addSubview(leftBottomUnderlineView)
        self.addSubview(rightBottomUnderlineView)
        self.updateConstraints()
    }

    override func updateConstraints() {
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.leftBottomUnderlineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(1)
        }

        self.rightBottomUnderlineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp.bottom)
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(1)
        }

        super.updateConstraints()
    }
}
