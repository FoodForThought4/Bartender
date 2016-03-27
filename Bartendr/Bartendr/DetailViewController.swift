//
//  DetailViewController.swift
//  Bartendr
//
//  Created by Brian Lee on 3/26/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ingredientDivider: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    
    var drink: Drink!
    var measurementList: String = ""
    var ingredientList: String = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        nameLabel.text = drink.name
        prepLabel.text = drink.description
        
        if let url = drink.imgURLBig {
            let imageRequest = NSURLRequest(URL: NSURL(string: url)!)
            
            drinkImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        self.drinkImageView.alpha = 0.0
                        self.drinkImageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.drinkImageView.alpha = 1.0
                        })
                    } else {
                        self.drinkImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        
        parseIngredients()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseIngredients(){
        for ingredient in drink.ingredients{
            var text = ingredient.text!
            var measurement = ingredient.text!
            text = (text.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
            text = text.stringByReplacingOccurrencesOfString("Parts", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Part", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Dash", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Twist", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Splash", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Slice", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("Slices", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            text = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            measurement = measurement.stringByReplacingOccurrencesOfString(text, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            measurement = measurement.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            ingredientList = ingredientList + "\(text)\n"
            measurementList = measurementList + "\(measurement)\n"
        }
        ingredientLabel.text = ingredientList
        measurementLabel.text = measurementList
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onShare(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension DetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
    }

}