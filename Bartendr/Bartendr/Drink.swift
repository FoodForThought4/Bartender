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
    var imgURLBig: String?
    var customImg: UIImage?
    var ingredientList = ""
    var likes: Int?
    
    var ingredients = [Ingredient]()
    
    init(drinkDetails: NSDictionary) {
        id = drinkDetails["id"] as? String
        name = drinkDetails["name"] as? String
        description = drinkDetails["descriptionPlain"] as? String
        imgURL = "https://assets.absolutdrinks.com/drinks/100x100/\(id!).png"
        imgURLBig = "https://assets.absolutdrinks.com/drinks/500x500/\(id!).png"
        likes = drinkDetails["likes"] as? Int
        
        for ingredient in (drinkDetails["ingredients"] as? [NSDictionary])! {
            ingredients.append(Ingredient(ingredientData: ingredient))
        }

        
        for ingredient in ingredients {
            var text = ingredient.text!
            text = (text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
            text = text.stringByReplacingOccurrencesOfString("Parts", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Part", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            ingredientList = ingredientList + "\(text), "
        }
        ingredientList = String(ingredientList.characters.dropLast(2))
    }
    
    class func convertDrinkToPFObject(newDrink: Drink) -> PFObject {
        let drink = PFObject(className: "Drink")
        
        // add details
        if let img = newDrink.customImg {
            drink["photo"] = ApiClient.getPFFileFromImage(img) // PFFile column type
        }
        
        drink["author"] = PFUser.currentUser() ?? "TestUser"
        drink["likes"] = 0
        drink["commentsCount"] = 0
        
        // TODO: Modify to only include neccessary data
        drink["id"] = newDrink.id ?? ApiClient.generateId()
        
        drink["name"] = newDrink.name
        drink["description"] = newDrink.description
        drink["ingredients"] = newDrink.ingredients
        
        return drink
    }
    
}