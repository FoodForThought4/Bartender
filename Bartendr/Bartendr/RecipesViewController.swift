//
//  RecipesViewController.swift
//  Bartendr
//
//  Created by Brian Lee on 3/8/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit
import XMSegmentedControl

class RecipesViewController: UIViewController, XMSegmentedControlDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var drinks: [Drink]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        let segmentedController = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentedControl.frame.width, height: 44), segmentTitle: ["Recipes", "Ingredients"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
        segmentedController.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 0)
        segmentedController.highlightColor = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 1)
        segmentedController.tint = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 0.5)
        segmentedController.highlightTint = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 1)
        segmentedController.font = UIFont(name: "Helvetica Neue", size: CGFloat(18))!
        
        segmentedController.delegate = self
        
        segmentedControl.addSubview(segmentedController)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int){
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let drinks = drinks{
            return drinks.count
        } else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCell", forIndexPath: indexPath) as! DrinkCell

        return cell
    }
    
    func networkRequest(){
        ApiClient.getDrinksADDB([]) { (drinkData, error) -> () in
            if error != nil{
                print("error")
            }else {
                //self.drinks = drinkData
            }
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
