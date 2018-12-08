//
//  ShoppingItemCell.swift
//  ZopNowJsonParsingDemo
//
//  Created by Akash Gurnale on 30/10/18.
//  Copyright © 2018 Akash Gurnale. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var shoppingItemImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
