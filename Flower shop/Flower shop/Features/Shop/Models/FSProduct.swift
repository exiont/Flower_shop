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
    var imageUrl: String
    var name: String
    var description: String
    var details: String
    var imageView: UIImageView = UIImageView()
    var image: UIImage? {
        self.imageView.image
    }

    init(id: Int = 0, image: String = "", price: Double = 0, name: String = "", description: String = "", details: String = "", isBouquet: Bool = false) {
        self.id = id
        self.isBouquet = isBouquet
        self.price = price
        self.imageUrl = image
        self.name = name
        self.description = description
        self.details = details
    }
}
