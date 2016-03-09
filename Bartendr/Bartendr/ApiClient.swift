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
    
    // get the drinks from ADDB api
    class func getDrinksADDB(params: AnyObject?, completion: (drinkData: [Drink]?, error: NSError?) -> ()) {
        http.GET(apiURL + "/drinks/?apiKey=\(addbApiKey)", parameters: [], progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                var drinks = [Drink]()
                
                for drink in response!["result"] as! NSArray {
                    drinks.append(Drink(drinkDetails: drink as! NSDictionary))
                }
                
                print("response = \(response)")
                completion(drinkData: drinks, error: nil)
                
            }) { (dataTask: NSURLSessionDataTask?, error: NSError) -> Void in
                
                print("failure retrieving drinks")
                completion(drinkData: nil, error: error)
        }
    }
    
    class func getDrinksParse(params: [String: String], completion: (drinkData: NSDictionary?, error: NSError?) -> ()) {
        let query = PFQuery(className: "Drink")
        
        for param in params {
            query.whereKey(param.0, containsString: param.1)
        }
        
        
//        query.getFirstObjectInBackgroundWithBlock { (var drink: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                
//                drink = Drink.convertDrinkToPFObject(updatedDrink)
//                drink?.saveInBackground()
//            } else {
//                print("error getting drink to update it")
//            }
//        }
        
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
        
        query.getFirstObjectInBackgroundWithBlock { (var drink: PFObject?, error: NSError?) -> Void in
            if error != nil {
                
                drink = Drink.convertDrinkToPFObject(updatedDrink)
                drink?.saveInBackground()
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