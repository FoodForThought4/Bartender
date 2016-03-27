//
//  ApiClient.swift
//  Bartendr
//
//  Created by Martynas Kausas on 3/1/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import Foundation
import AFNetworking
import Parse

class ApiClient {
    
    static let http = AFHTTPSessionManager()
    static let apiURL = "https://addb.absolutdrinks.com"
    static var addbApiKey: String!
    static var nextPageURL: String?
        
    
    // get the drinks from ADDB api
    class func getDrinksADDB(ingredients: [AnyObject], nextPage: Bool, completion: (drinkData: [Drink]?, error: NSError?) -> ()) {
        
        var url: String
        if let nextPageURL = nextPageURL where nextPage == true {
            url = nextPageURL
        } else {
            
            url = apiURL + "/drinks" //?apiKey=\(addbApiKey)"
            
            // add ingredients if specified
            for i in 0 ..< ingredients.count {
                url += "/withtype/\(ingredients[i])" // change this to non-type when more ingredients are implementedim
            }
        }
        
        url += "?apiKey=\(addbApiKey)"
        
        http.GET(url, parameters: [], progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                var drinks = [Drink]()
                
                for drink in response?.valueForKey("result") as! NSArray {
                    drinks.append(Drink(drinkDetails: drink as! NSDictionary))
                }
                
                if let next = response?.valueForKey("next") as? String {
                    nextPageURL = next
                }
                
                completion(drinkData: drinks, error: nil)
                
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                
                print("failure retrieving drinks")
                completion(drinkData: nil, error: error)
        }
    }
    
    class func searchDrinkADDB(drinkSubstring: String, nextPage: Bool, completion: (drinkData: [Drink]?, error: NSError?) -> ()) {
        
        
        print("\(apiURL)/quickSearch/drinks/\(drinkSubstring)/?apiKey=\(addbApiKey)")
        http.GET("\(apiURL)/quickSearch/drinks/\(drinkSubstring)/?apiKey=\(addbApiKey)", parameters: [], progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                var drinks = [Drink]()
                
                for drink in response?.valueForKey("result") as! NSArray {
                    drinks.append(Drink(drinkDetails: drink as! NSDictionary))
                }
                
                nextPageURL = response?.valueForKey("next") as? String
                
                completion(drinkData: drinks, error: nil)
                
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                
                print("failure retrieving drinks")
                completion(drinkData: nil, error: error)
        }
    }
    
    
    class func getDrinksParse(params: [String: String]?, completion: (drinkData: NSDictionary?, error: NSError?) -> ()) {
        let query = PFQuery(className: "Drink")
        
        if let params = params {
            for param in params {
                query.whereKey(param.0, containsString: param.1)
            }
        }
        
        query.findObjectsInBackgroundWithBlock { (drinks: [PFObject]?, error: NSError?) -> Void in
            print("Drinks = \(drinks)")
        }
        
    }
    
    
    // send a drink to parse server
    class func createDrink(drink: Drink, completion: (success: Bool) -> ()) {
        // Create Parse object PFObject
        let drink = Drink.convertDrinkToPFObject(drink)
        
        // Save object (following function will save the object in Parse asynchronously)
        drink.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            if success == true {
                print("success posting new drink")
                completion(success: true)
            } else {
                print("error posting new drink: \(error?.description)")
                completion(success: false)
            }
        })
    }
    
    
    // add a like to a user created drink
    class func likeDrink(drinkID: String, rating: Double) {
        let query = PFQuery(className: "Drink")
        query.whereKey("id", containsString: drinkID)
        
        query.getFirstObjectInBackgroundWithBlock { (drink: PFObject?, error: NSError?) -> Void in
            if error != nil {
                drink!["likes"] = drink!["likes"] as! Int + 1
                drink?.saveInBackground()
            } else {
                print("error getting drink to like it")
            }
        }
    }
    
    class func updateDrink(updatedDrink: Drink) {
        let query = PFQuery(className: "Drink")
        query.whereKey("id", containsString: updatedDrink.id)
        
        query.getFirstObjectInBackgroundWithBlock { (drink: PFObject?, error: NSError?) -> Void in
            if error != nil {
                
                let updatedDrinkObject = Drink.convertDrinkToPFObject(updatedDrink)
                updatedDrinkObject.saveInBackground()
            } else {
                print("error getting drink to update it")
            }
        }
    }
    
    class func shareDrink(drink: Drink) -> Bool {
        
        return false
    }
    
    

    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}