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
    
    init(ingredientData: NSDictionary) {
        id = ingredientData["id"] as? String
        text = ingredientData["textPlain"] as? String
    }
}