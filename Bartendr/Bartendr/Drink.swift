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
    var descriptionPlain: String?
    var story: String?
    var color: String?
    var languageBranch: String?
    var rating: Int?
    var skill: NSDictionary?
    var video: [NSDictionary]?
    var isAlcoholic: Bool?
    var isCarbonated: Bool?
    var isHot: Bool?
    var servedIn: NSDictionary?
    var ingredients = [Ingredient]()
    var tastes: [NSDictionary]?
    var occasions: [NSDictionary]?
    var tools: [NSDictionary]?
    var drinkTypes: NSArray?
    var actions: [NSDictionary]?
    var brands: NSArray?
    var tags: [NSDictionary]?
    
    
    var img: UIImage? {
        set(image) {
            self.img = image
        }
        
        get {
            // if image not already set
            if self.img == nil {
                let tempView = UIImageView()
                tempView.setImageWithURL(NSURL(string: "http://assets.absolutdrinks.com/drinks/\(id!).png")!)
                self.img = tempView.image
            }
            
            return self.img
        }
    }
    
    init(drinkDetails: NSDictionary) {
        id = drinkDetails["id"] as? String
        name = drinkDetails["name"] as? String
        description = drinkDetails["description"] as? String
        descriptionPlain = drinkDetails["descriptionPlain"] as? String
        story = drinkDetails["story"] as? String
        color = drinkDetails["color"] as? String
        languageBranch = drinkDetails["languageBranch"] as? String
        rating = drinkDetails["rating"] as? Int
        skill = drinkDetails["skill"] as? NSDictionary
        video = drinkDetails["video"] as? [NSDictionary]
        isAlcoholic = drinkDetails["isAlcoholic"] as? Bool
        isCarbonated = drinkDetails["isCarbonated"] as? Bool
        isHot = drinkDetails["isHot"] as? Bool
        servedIn = drinkDetails["servedIn"] as? NSDictionary
        tastes = drinkDetails["tastes"] as? [NSDictionary]
        occasions = drinkDetails["occasions"] as? [NSDictionary]
        tools = drinkDetails["tools"] as? [NSDictionary]
        drinkTypes = drinkDetails["drinkTypes"] as? NSArray
        actions = drinkDetails["actions"] as? [NSDictionary]
        brands = drinkDetails["brands"] as? NSArray
        tags = drinkDetails["tags"] as? [NSDictionary]
        
        for ingredient in (drinkDetails["ingredients"] as? [NSDictionary])! {
            ingredients.append(Ingredient(ingredientData: ingredient))
        }
    }
    
    class func convertDrinkToPFObject(newDrink: Drink) -> PFObject {
        let drink = PFObject(className: "Drink")
        
        // add details
        drink["photo"] = ApiClient.getPFFileFromImage(newDrink.img) // PFFile column type
        drink["author"] = PFUser.currentUser()
        drink["likes"] = 0
        drink["commentsCount"] = 0
        
        // TODO: Modify to only include neccessary data
        drink["id"] = newDrink.id
        drink["name"] = newDrink.name
        drink["description"] = newDrink.description
        drink["descriptionPlain"] = newDrink.descriptionPlain
        drink["story"] = newDrink.story
        drink["color"] = newDrink.color
        drink["languageBranch"] = newDrink.languageBranch
        drink["rating"] = newDrink.rating
        drink["skill"] = newDrink.skill
        drink["video"] = newDrink.video
        drink["isAlcoholic"] = newDrink.isAlcoholic
        drink["isCarbonated"] = newDrink.isCarbonated
        drink["isHot"] = newDrink.isHot
        drink["servedIn"] = newDrink.servedIn
        drink["ingredients"] = newDrink.ingredients
        drink["tastes"] = newDrink.tastes
        drink["occasions"] = newDrink.occasions
        drink["tools"] = newDrink.tools
        drink["drinkTypes"] = newDrink.drinkTypes
        drink["actions"] = newDrink.actions
        drink["brands"] = newDrink.brands
        drink["tags"] = newDrink.tags
        
        return drink
    }
    
}