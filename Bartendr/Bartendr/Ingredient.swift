//
//  Ingredient.swift
//  Bartendr
//
//  Created by Martynas Kausas on 3/1/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import Foundation


class Ingredient {
    var type: String?
    var id: String?
    var text: String?
    var textPlain: String?
    
    init(ingredientData: NSDictionary) {
        type = ingredientData["type"] as? String
        id = ingredientData["id"] as? String
        text = ingredientData["text"] as? String
        textPlain = ingredientData["textPlain"] as? String
    }
}