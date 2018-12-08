//
//  ShoppingListModel.swift
//  ZopNowJsonParsingDemo
//
//  Created by Akash Gurnale on 01/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import Foundation

class ShoppingListModel {
    var productId: String
    var productName: String
    var productFullName: String
    var brandId: String
    var brandName: String
    var productCount: String
    var imageUrl: String
    var variants: Array<ShoppingListVariants>
    
    init(
        productId: String,
        productName: String,
        productFullName: String,
        brandName: String,
        brandId: String,
        productCount: String,
        imageUrl: String,
        variants: Array<ShoppingListVariants>
        ) {
        
        self.productId = productId
        self.productName = productName
        self.productFullName = productFullName
        self.brandId = brandId
        self.brandName = brandName
        self.productCount = productCount
        self.imageUrl = imageUrl
        self.variants = variants
    }
}
