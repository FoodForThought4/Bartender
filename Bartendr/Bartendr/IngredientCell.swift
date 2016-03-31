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
    @IBOutlet weak var amountField: UITextField!
    
    var amount = 0
    
    var isSelected: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isSelected = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPlus(sender: AnyObject) {
        if isSelected == true {
            amount += 1
            amountField.text = "\(amount)"
        }
    }

    @IBAction func onMinus(sender: AnyObject) {
        if amount > 0 && isSelected == true {
            amount -= 1
            amountField.text = "\(amount)"
        }
    }
    
}
