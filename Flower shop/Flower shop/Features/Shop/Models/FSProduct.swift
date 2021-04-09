//
//  FSProduct.swift
//  Flower shop
//
//  Created by New on 7.04.21.
//

import UIKit

struct FSProduct {
    let id: String
    let image: UIImage?
    let price: Double
    let name: String
    let description: String
    let details: String
    let isBouquet: Bool

    init(id: String, image: UIImage?, price: Double, name: String, description: String, details: String = "", isBouquet: Bool = false) {
        self.id = id
        self.image = image
        self.price = price
        self.name = name
        self.description = description
        self.details = details
        self.isBouquet = isBouquet
    }
}
