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
            url += "?apiKey=\(addbApiKey)"
        }
        
        getDrinksFromUrl(url) { (drinkData, error) in
            completion(drinkData: drinkData, error: error)
        }
    }
    
    class func getDrinksFromUrl(url: String, completion: (drinkData: [Drink]?, error: NSError?) -> ()) {
        http.GET(url, parameters: [], progress: { (progress: NSProgress) -> Void in
            }, success: { (dataTask: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                let drinks = getDrinkFromResponse(response)
                
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
        
        getDrinksFromUrl("\(apiURL)/quickSearch/drinks/\(drinkSubstring)/?apiKey=\(addbApiKey)") { (drinkData, error) in
            completion(drinkData: drinkData, error: error)
        }
    }
    
    
    class func getDrinksParse(params: [String: String]?, completion: (drinkData: [Drink]?, error: NSError?) -> ()) {
        let query = PFQuery(className: "Drink")
        
        if let params = params {
            for param in params {
                query.whereKey(param.0, containsString: param.1)
            }
        }
        
        query.findObjectsInBackgroundWithBlock { (drinks: [PFObject]?, error: NSError?) -> Void in
            
            let newDrinks = getDrinkFromParseResponse(drinks)
            
            if error == nil {
                completion(drinkData: newDrinks, error: nil)
                print("Drinks = \(drinks)")
            } else {
                completion(drinkData: nil, error: error)
                print("error")
            }
            
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
    class func likeDrink(drink: Drink) {
        let query = PFQuery(className: "Drink")
        query.whereKey("id", containsString: drink.id)
        
        query.getFirstObjectInBackgroundWithBlock { (drinkObject: PFObject?, error: NSError?) -> Void in
            if let drinkObject = drinkObject where error != nil {

                if let likes = drinkObject["likes"] as? Int {
                    drinkObject["likes"] = likes + 1
                } else {
                    drinkObject["likes"] = 1
                }
                
                drinkObject.saveInBackgroundWithBlock({ (success, error) in
                    if error == nil {
                        print("success liking!")
                    } else {
                        print(error)
                    }
                })

            }
            
            else {
                print("drink not yet saved")
                // drink not yet saved in parse (probably only ADDB)
                drink.likes = 1
                
                let newDrinkObject = Drink.convertDrinkToPFObject(drink)
                newDrinkObject.saveInBackgroundWithBlock({ (success, error) in

                    if error == nil {
                        print("success liking!")
                    } else {
                        print(error)
                    }
                })
            }
        }
    }
    
    class func updateDrink(updatedDrink: Drink) {
        let query = PFQuery(className: "Drink")
        query.whereKey("id", containsString: updatedDrink.id)
        query.includeKey("ingredients")
        
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
    
    
    class func generateId() -> String {
        var newID: String = ""
        if (newID.isEmpty || idUsed(newID)) {
            newID = ""
            for _ in 0 ..< 8 {
                newID += "\(arc4random_uniform(1))"
            }
        }
        
        return newID
    }
    
    private class func getDrinkFromResponse(response: AnyObject?) -> [Drink] {
        var drinks = [Drink]()
        
        for drink in response?.valueForKey("result") as! NSArray {
            drinks.append(Drink(drinkDetails: drink as! NSDictionary))
        }
        
        return drinks
    }
    
    private class func getDrinkFromParseResponse(response: [PFObject]?) -> [Drink] {
        var drinks = [Drink]()
        
        for drink in response! {
            print("id = \(drink["id"])")
            drinks.append(Drink(drinkDetails: drink))
        }
        
        return drinks
    }
    
    class func idUsed(id: String) -> Bool {
        let query = PFQuery(className: "Drink")
        
//        query.getFirstObjectInBackgroundWithBlock { (drink: PFObject?, error: NSError?) in
//            if error == nil {
//                return true
//            } else {
//                return false
//            }
//        }
        
        return false
    }
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            let resizedImage = ApiClient.resize(image, newSize: CGSize(width: image.size.width/4, height: image.size.width/4))
            
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(resizedImage) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
