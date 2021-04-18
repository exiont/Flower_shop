//
//  FSProduct.swift
//  Flower shop
//
//  Created by New on 7.04.21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

struct FSProduct {
    var id: Int
    var isBouquet: Bool
    var price: Double
    var image: UIImage?
    var name: String
    var description: String
    var details: String

    init(id: Int = 0, image: UIImage? = nil, price: Double = 0, name: String = "", description: String = "", details: String = "", isBouquet: Bool = false) {
        self.id = id
        self.isBouquet = isBouquet
        self.price = price
        self.image = image
        self.name = name
        self.description = description
        self.details = details
    }
}
