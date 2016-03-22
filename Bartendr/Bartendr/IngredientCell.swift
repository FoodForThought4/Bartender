//
//  IngredientCell.swift
//  Bartendr
//
//  Created by Brian Lee on 3/16/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    var isSelected: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
