//
//  Ingredient.swift
//  Bartendr
//
//  Created by Martynas Kausas on 3/1/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import Foundation


class Ingredient {
    var id: String?
    var text: String?
    var type: String?
    
    static var TYPES = [["BaseSpirit", "spirits-other", "tequila", "vodka", "whisky", "brandy", "rum", "gin"], ["berries", "decoration", "fruits", "mixers"], ["others", "ice", "spices-herbs"]]
    
    static var TYPES_DIC = ["BaseSpirit": "Spirit", "spirits-other": "Other", "tequila": "Tequila", "vodka": "Vodka", "whisky": "Whisky", "brandy": "Brandy", "rum": "Rum", "gin": "Gin", "berries": "Berries", "decoration": "Decoration", "fruits": "Fruits", "mixers": "Mixers", "others": "Others", "ice": "Ice", "spices-herbs": "Spices/Herbs"]
    
    init(id:String, text: String) {
        self.id = id
        self.text = text
    }
 
    init(ingredientData: NSDictionary) {
        if let id = ingredientData["id"] as? String {
            self.id = id
        }
        
        if let text = ingredientData["textPlain"] as? String {
            self.text = text
        }
        
        // deal with parse crap
        else {
            let sortedKeys = (ingredientData.allKeys as! [String]).sort(<) // ["a", "b"]
            id = ingredientData[sortedKeys[0]] as? String
            if sortedKeys.count > 1 {
                text = ingredientData[sortedKeys[1]] as? String
            } else {
                text = ""
            }
        }
    }
}