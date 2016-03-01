//
//  ApiClient.swift
//  Bartendr
//
//  Created by Martynas Kausas on 3/1/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import Foundation

class ApiClient {
    
    func getDrinks(filters: [String]) -> [Drink] {
        return [Drink]()
    }
    
    
    func createDrink(drink: Drink) -> Bool {
        return false
    }
    
    
    func rateDrink(drink: Drink, rating: Double) -> Bool {
        return false
    }
    
    
    func shareDrink(drink: Drink) -> Bool {
        return false
    }
    
    
    func updateDrink(drinkID: Int, drink: Drink) -> Bool {
        return false
    }
    
}