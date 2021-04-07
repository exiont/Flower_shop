//
//  FSProduct.swift
//  Flower shop
//
//  Created by New on 7.04.21.
//

import UIKit

struct FSProduct {
    let image: UIImage?
    let name: String
    let description: String
    let isBouquet: Bool

    init(image: UIImage?, name: String, description: String, isBouquet: Bool = false) {
        self.image = image
        self.name = name
        self.description = description
        self.isBouquet = isBouquet
    }
}
