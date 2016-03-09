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

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var drinks = [Drink]()
    var currentView = 0
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
    
        setupSegmentedControl()
        setupCollectionView()

        getDrinks(false)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        let layout = SACollectionViewVerticalScalingFlowLayout()
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
    }
    
    func setupSegmentedControl() {
        let segmentedController = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentedControl.frame.width, height: 44), segmentTitle: ["Recipes", "Ingredients"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
        segmentedController.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 0)
        segmentedController.highlightColor = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 1)
        segmentedController.tint = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 0.5)
        segmentedController.highlightTint = UIColor(red: 84/255, green: 214/255, blue: 130/255, alpha: 1)
        segmentedController.font = UIFont(name: "Helvetica Neue", size: CGFloat(18))!
        
        segmentedController.delegate = self
        
        segmentedControl.addSubview(segmentedController)
    }
    
    func getDrinks(nextPage: Bool) {
        ApiClient.getDrinksADDB([], nextPage: nextPage) { (drinkData, error) -> () in
            if error != nil{
                print("error")
            } else {
                if nextPage {
                    self.drinks += drinkData!
                } else {
                    self.drinks = drinkData!
                }
                
                self.collectionView.reloadData()
            }
            
            self.isMoreDataLoading = false
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getDrinks(false)
        refreshControl.endRefreshing()
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

extension RecipesViewController: XMSegmentedControlDelegate {
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
}


extension RecipesViewController: UICollectionViewDelegate {
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
        
        
        // paging for fetching new data
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = scrollView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - scrollView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && scrollView.dragging) {
                
                isMoreDataLoading = true
                
                // load more results
                getDrinks(true)
            }
        }
    }
}

extension RecipesViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return drinks.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCell", forIndexPath: indexPath) as! DrinkCell
        
        cell.drink = drinks[indexPath.row]
        
        return cell
    }

}
