//
//  UIFont+Ex.swift
//  Flower shop
//
//  Created by New on 7.04.21.
//

import UIKit

extension UIFont {
    static func applyCustomFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
        //"Caveat-Regular"
    }
}
