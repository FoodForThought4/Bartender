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
    var measurementList: String = ""
    var ingredientList = ""
    var ingredientListShort = ""
    var likes: Int?
    
    var ingredients = [Ingredient]()
    
    let quantityTypes = ["On Cocktail Sticks", "Tablespoons", "Tablespoon", "Leaves", "Leaf", "Peels", "Peel", "Spiral", "Halves", "Half", "Parts", "Part", "Dashes", "Dash", "Twist", "Splashes", "Splash", "Slices", "Slice", "Whole", "Wedges", "Wedge", "Wheel", "Pieces", "Piece"]
    let quantityFractions = ["½", "¾", "⅓", "¼"]
    
    
    init(name: String, description: String, customImg: UIImage, ingredients: [Ingredient]) {
        self.name = name
        self.description = description
        self.customImg = customImg
        self.ingredients = ingredients
    }
    
    init(drinkDetails: PFObject) {
        initializeDrink(drinkDetails)
    }
    
    init(drinkDetails: NSDictionary) {
        initializeDrink(drinkDetails)
    }
    
    func initializeDrink(drinkDetails: AnyObject) {
        id = drinkDetails.objectForKey("id") as? String
        name = drinkDetails.objectForKey("name") as? String
        description = drinkDetails.objectForKey("descriptionPlain") as? String
        
        if let img = drinkDetails.objectForKey("photo") {
            
            img.getDataInBackgroundWithBlock({ (data, error) in
                if error == nil {
                    self.customImg = UIImage(data: data!)
                }
            })
        }
            
        else if let id = id {
            imgURL = "https://assets.absolutdrinks.com/drinks/100x100/\(id).png"
            imgURLBig = "https://assets.absolutdrinks.com/drinks/500x500/\(id).png"
        }
        
        if let allIngredients = drinkDetails.objectForKey("ingredients") as? [NSDictionary] {
            for ingredient in allIngredients {
                ingredients.append(Ingredient(ingredientData: ingredient))
            }
            
            for ingredient in ingredients {
                var text = ingredient.text!
                var measurement = ingredient.text!
                
                for quantityFraction in quantityFractions{
                    text = text.stringByReplacingOccurrencesOfString(quantityFraction, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                
                text = (text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
                
                for quantityType in quantityTypes{
                    text = text.stringByReplacingOccurrencesOfString(quantityType, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                
                text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                measurement = measurement.stringByReplacingOccurrencesOfString(text, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                measurement = measurement.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                ingredientListShort = ingredientListShort + "\(text), "
                ingredientList = ingredientList + "\(text)\n"
                if measurement == "" {
                    measurement = "-"
                }
                measurementList = measurementList + "\(measurement)\n"
            }
        }
        ingredientListShort = String(ingredientListShort.characters.dropLast(2))
        print(ingredientListShort)
    }
    
    class func convertDrinkToPFObject(newDrink: Drink) -> PFObject {
        let drink = PFObject(className: "Drink")
        
        // add details
        
        drink["author"] = PFUser.currentUser() ?? "TestUser"
        if newDrink.customImg != nil {
            drink["photo"] = ApiClient.getPFFileFromImage(newDrink.customImg)
        } else {
            drink["photo"] = ApiClient.getPFFileFromImage(UIImage(named: "defaultDrink"))
        }
        
        //drink["photo"] = ApiClient.getPFFileFromImage(newDrink.customImg) // PFFile column type
        //drink["author"] = PFUser.currentUser()
        drink["likes"] = 0
        
        // TODO: Modify to only include neccessary data
        drink["id"] = newDrink.id ?? ApiClient.generateId()
        
        drink["name"] = newDrink.name
        drink["descriptionPlain"] = newDrink.description
        
        let ingredients = NSMutableArray()
        for ingredient in newDrink.ingredients {
            let newIngredient = NSMutableDictionary()
            newIngredient["id"] = ingredient.id
            newIngredient["text"] = ingredient.text
            ingredients.addObject(newIngredient)
            
        }
        drink["ingredients"] = ingredients
        
        //drink["ingredients"] = ingredientArray
        
        return drink
    }
    
}
