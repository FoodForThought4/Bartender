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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numLikedLabel: UILabel!
    
    var drink: Drink!
    var measurementList: String = ""
    var ingredientList: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        nameLabel.text = drink.name
        prepLabel.text = drink.description
        ingredientLabel.text = drink.ingredientList
        measurementLabel.text = drink.measurementList
        
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
        
        if let image = drink.customImg {
            self.drinkImageView.alpha = 0.0
            self.drinkImageView.image = image
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.drinkImageView.alpha = 1.0
            })
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onShare(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Name: \(drink.name!)\n Ingredients: \(ingredientList)"
        messageVC.messageComposeDelegate = self
        
        if MFMessageComposeViewController.canSendText() {
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}