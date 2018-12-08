//
//  ShoppingListVariants.swift
//  ZopNowJsonParsingDemo
//
//  Created by Akash Gurnale on 01/11/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import Foundation

class ShoppingListVariants {
    
    var variantId: String
    var nameQuantity: String
    var variantFullName: String
    var status: String
    var currency: String
    var mrp: Int
    var discount: Double
    
    init(
        variantId: String,
        nameQuantity: String,
        variantFullName: String,
        status: String,
        currency: String,
        mrp: Int,
        discount: Double
        ) {
        self.variantId = variantId
        self.nameQuantity = nameQuantity
        self.variantFullName = variantFullName
        self.status = status
        self.currency = currency
        self.mrp = mrp
        self.discount = discount
    }
}
