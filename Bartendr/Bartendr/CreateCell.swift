//
//  CreateCell.swift
//  Bartendr
//
//  Created by Lainie Wright on 3/26/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

@objc protocol CreateCellDelegate {
    optional func createCell(createCell: CreateCell, didChangeValue value: Bool)
}

class CreateCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    weak var delegate: CreateCellDelegate?
    
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
    
    func checkBoxValueChanged() {
        if (isSelected == true) {
            isSelected = false
        } else {
            isSelected = true
        }
        delegate?.createCell?(self, didChangeValue: isSelected!)
    }
    
}
