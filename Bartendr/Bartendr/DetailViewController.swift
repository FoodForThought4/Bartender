//
//  DetailViewController.swift
//  Bartendr
//
//  Created by Brian Lee on 3/26/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var drink: Drink!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = drink.name
        
        if let url = drink.imgURL {
            let imageRequest = NSURLRequest(URL: NSURL(string: url)!)
            
            drinkImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.drinkImageView.alpha = 0.0
                        self.drinkImageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.drinkImageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.drinkImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
