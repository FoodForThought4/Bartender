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
    
    
    init(name: String, description: String, customImg: UIImage, ingredients: [Ingredient]) {
        self.name = name
        self.description = description
        self.customImg = customImg
        self.ingredients = ingredients
    }
    
    init(drinkDetails: NSDictionary) {
        id = drinkDetails["id"] as? String
        name = drinkDetails["name"] as? String
        description = drinkDetails["descriptionPlain"] as? String
       
        if let id = id {
            imgURL = "https://assets.absolutdrinks.com/drinks/100x100/\(id).png"
            imgURLBig = "https://assets.absolutdrinks.com/drinks/500x500/\(id).png"
        }
       
        if let allIngredients = drinkDetails["ingredients"] as? [NSDictionary] {
            for ingredient in allIngredients {
                ingredients.append(Ingredient(ingredientData: ingredient))
            }
        
            for ingredient in ingredients {
                var text = ingredient.text!
                text = text.stringByReplacingOccurrencesOfString("½", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("¾", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("⅓", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("¼", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = (text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
                text = text.stringByReplacingOccurrencesOfString("On Cocktail Sticks", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Tablespoons", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Tablespoon", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Leaves", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Leaf", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Peels", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Peel", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Spiral", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Halves", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Half", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Parts", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Part", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Dashes", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Dash", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Twist", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Splashes", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Splash", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Slices", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Slice", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Whole", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Wedges", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Wedge", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByReplacingOccurrencesOfString("Wheel", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if !text.containsString("Ice Cubes"){
                    ingredientList = ingredientList + "\(text), "
                }
            }
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
        
        // TODO: Modify to only include neccessary data
        drink["id"] = newDrink.id ?? ApiClient.generateId()
        drink["name"] = newDrink.name
        drink["description"] = newDrink.description
        
        let ingredients = NSMutableArray()
        for ingredient in newDrink.ingredients {
            var newIngredient = NSMutableDictionary()
            newIngredient["id"] = 213
            newIngredient["text"] = "this is text"
            ingredients.addObject(newIngredient)
            
        }
        drink["ingredients"] = ingredients
        
        return drink
    }
    
}
