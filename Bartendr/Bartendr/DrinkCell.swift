//
//  DrinkCell.swift
//  Bartendr
//
//  Created by Brian Lee on 3/8/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class DrinkCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!

    var drink: Drink! {
        didSet {
            titleLabel.text = drink.name
            descriptionLabel.text = drink.ingredientList
            backgroundImageView.image = UIImage(named: "CellBackground")
            
            // drink from parse
            if let img = drink.customImg {
                drinkImageView.image = img
            }
            
            else if let url = drink.imgURL {
                let imageRequest = NSURLRequest(URL: NSURL(string: url)!)
                
                drinkImageView.image = nil
                drinkImageView.setImageWithURLRequest(
                    imageRequest,
                    placeholderImage: nil,
                    success: { (imageRequest, imageResponse, image) -> Void in
                        
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            self.drinkImageView.alpha = 0.0
                            self.drinkImageView.image = image
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self.drinkImageView.alpha = 1.0
                            })
                        } else {
                            self.drinkImageView.image = image
                        }
                    },
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        // do something for the failure condition
                })
            } else if let customImg = drink.customImg {
                self.drinkImageView.alpha = 0.0
                self.drinkImageView.image = customImg
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.drinkImageView.alpha = 1.0
                })
            }
            
            // use default image
            else {
                drinkImageView.image = UIImage(named: "defaultDrink")
            }
            
        }
    }
}
