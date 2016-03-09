//
//  RecipesViewController.swift
//  Bartendr
//
//  Created by Brian Lee on 3/8/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit
import XMSegmentedControl
import AFNetworking
import SACollectionViewVerticalScalingFlowLayout

class RecipesViewController: UIViewController, XMSegmentedControlDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var drinks: [Drink]?
    var currentView = 0
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = SACollectionViewVerticalScalingFlowLayout()
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        networkRequest()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int){
        if selectedSegment == 0 && currentView != 0{
            UIView.animateWithDuration(0.3, animations: {
                self.collectionView.frame.origin.x = 0
            })
            currentView = 0
            
        } else if selectedSegment == 1 && currentView != 1{
            UIView.animateWithDuration(0.3, animations: {
                self.collectionView.frame.origin.x = -400
            })
            currentView = 1
        }
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
        
        cell.titleLabel.text = drinks![indexPath.row].name
        cell.descriptionLabel.text = drinks![indexPath.row].ingredientList
        cell.backgroundImageView.image = UIImage(named: "CellBackground")
        if let url = drinks![indexPath.row].imgURL{
            let imageURL = NSURL(string: url)
            cell.drinkImageView.setImageWithURL(imageURL!)
        }
        
        return cell
    }
    
    func networkRequest(){
        ApiClient.getDrinksADDB([]) { (drinkData, error) -> () in
            if error != nil{
                print("error")
            }else {
                self.drinks = drinkData
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let s = CGSize(width: 316, height: 106)
            return s
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 20 && scrollView.contentOffset.y < 100{
            self.segmentedControl.frame.origin.y = 20 - (scrollView.contentOffset.y - 20)
        }
        if scrollView.contentOffset.y > 100{
            self.segmentedControl.frame.origin.y = -100
        }
        if scrollView.contentOffset.y < 20{
            self.segmentedControl.frame.origin.y = 20
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
