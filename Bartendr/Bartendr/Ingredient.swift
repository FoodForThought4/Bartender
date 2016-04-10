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
    
//    static var BaseSpirit = "BaseSpirit"
//    static var berries = "berries"
//    static var brandy = "brandy"
//    static var decoration = "decoration"
//    static var fruits = "fruits"
//    static var gin = "gin"
//    static var ice = "ice"
//    static var mixers = "mixers"
//    static var others = "others"
//    static var rum = "rum"
//    static var spicesHerbs = "spices-herbs"
//    static var spiritsOther = "spirits-other"
//    static var tequila = "tequila"
//    static var vodka = "vodka"
//    static var whisky = "whisky"
    
//    static var TYPES = ["BaseSpirit", "berries", "brandy", "decoration", "fruits", "gin", "ice", "mixers", "others", "rum", "spices-herbs", "spirits-other", "tequila", "vodka", "whisky"]
    
    static var TYPES = [["BaseSpirit", "spirits-other", "tequila", "vodka", "whisky", "brandy", "rum", "gin"], ["berries", "decoration", "fruits", "mixers"], ["others", "ice", "spices-herbs"]]
    
    init(id: String, text: String) {
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