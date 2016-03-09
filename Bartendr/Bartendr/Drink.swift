//
//  Drink.swift
//  Bartendr
//
//  Created by Martynas Kausas on 3/1/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
import Parse

class Drink {
    
    var id: String?
    var name: String?
    var description: String?
    var imgURL: String?
    var customImg: UIImage?
    
    var ingredients = [Ingredient]()
    
    init(drinkDetails: NSDictionary) {
        id = drinkDetails["id"] as? String
        name = drinkDetails["name"] as? String
        description = drinkDetails["descriptionPlain"] as? String
        imgURL = "http://assets.absolutdrinks.com/drinks/100x100/\(id!).png"
        
        for ingredient in (drinkDetails["ingredients"] as? [NSDictionary])! {
            ingredients.append(Ingredient(ingredientData: ingredient))
        }
    }
    
    class func convertDrinkToPFObject(newDrink: Drink) -> PFObject {
        let drink = PFObject(className: "Drink")
        
        // add details
        drink["photo"] = ApiClient.getPFFileFromImage(newDrink.customImg) // PFFile column type
        drink["author"] = PFUser.currentUser()
        drink["likes"] = 0
        drink["commentsCount"] = 0
        
        // TODO: Modify to only include neccessary data
        drink["id"] = newDrink.id
        drink["name"] = newDrink.name
        drink["description"] = newDrink.description
        drink["ingredients"] = newDrink.ingredients
        
        return drink
    }
    
}