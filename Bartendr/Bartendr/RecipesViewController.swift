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

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    
    var drinks = [Drink]()
    var filteredDrinks: [Drink]?
    
    var currentView = 0
    var isMoreDataLoading = false
    
    var lastContentOffset = CGFloat(0)
    var trackContentOffset = CGFloat(0)
    var scrollingDown = true
    var middleZone = false
    var segmentedControlHidden = false
    
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        setupSegmentedControl()
        setupCollectionView()
        
        configureCustomSearchController()
        
        getDrinks(false)
        
        print(searchView.frame.origin.x)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissSearch")
        collectionView.backgroundView = UIView()
        collectionView.backgroundView!.addGestureRecognizer(tap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        collectionView.addGestureRecognizer(leftSwipe)
        collectionView.addGestureRecognizer(rightSwipe)
    }
    
    func swipeLeft(){
        //segmentedControl.selectedSegment = 1
        print("1")
    }
    
    func swipeRight(){
        //segmentedControl.selectedSegment = 0
        print("0")
        
    }
    
    func dismissSearch(){
        view.endEditing(true)
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
                    self.filteredDrinks = drinkData!
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

extension RecipesViewController: CustomSearchControllerDelegate{
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRectMake(10.0, 5.0, collectionView.frame.size.width - 25, 40.0), searchBarFont: UIFont(name: "Avenir Next Condensed Heavy", size: 16.0)!, searchBarTextColor: UIColor.grayColor(), searchBarTintColor: UIColor.clearColor())
        
        customSearchController.customSearchBar.placeholder = "Search for drinks..."
        customSearchController.customDelegate = self
        searchView.addSubview(customSearchController.customSearchBar)
    }
    
    func didStartSearching() {
        shouldShowSearchResults = true
        collectionView.reloadData()
    }
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            collectionView.reloadData()
        }
    }
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        collectionView.reloadData()
    }
    
    func didChangeSearchText(var searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        if searchText.isEmpty{
            shouldShowSearchResults = false
        } else {
            
            searchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "/")
            ApiClient.searchDrinkADDB(searchText, nextPage: false, completion: { (drinkData, error) -> () in
                if error == nil {
                    print("success!")
                    self.filteredDrinks = drinkData
                } else {
                    print("error retrieving searched items")
                }
            })

            shouldShowSearchResults = true
        }
        
        // Reload the tableview.
        collectionView.reloadData()
    }
}

extension RecipesViewController: XMSegmentedControlDelegate {
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment:Int){
        if selectedSegment == 0 && currentView != 0{
            UIView.animateWithDuration(0.3, animations: {
                self.collectionView.frame.origin.x = 0
                self.searchView.frame.origin.x = 30
            })
            currentView = 0
            
        } else if selectedSegment == 1 && currentView != 1{
            UIView.animateWithDuration(0.3, animations: {
                self.collectionView.frame.origin.x = -400
                self.searchView.frame.origin.x = -370
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
        
        for cell in collectionView.visibleCells() as [UICollectionViewCell] {
            
            let point = collectionView.convertPoint(cell.center, toView: collectionView.superview)
            cell.alpha = (point.y - 80) / 50
        }
        
        if scrollView.contentOffset.y > lastContentOffset && scrollView.contentOffset.y > 0 {
            scrollingDown = true
        }
        if scrollView.contentOffset.y < lastContentOffset && scrollView.contentOffset.y > 0 {
            scrollingDown = false
        }
        
        //hiding and showing segmentedControl when reaching the top of the scrollView
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 150{
            //&& ((!segmentedControlHidden && scrollingDown) || (segmentedControlHidden && !scrollingDown)) {
                if scrollView.contentOffset.y > 40{
                    self.searchView.frame.origin.y = 38
                } else if scrollView.contentOffset.y < 0 {
                    self.searchView.frame.origin.y = 77
                } else {
                    self.searchView.frame.origin.y = 77 - (scrollView.contentOffset.y)
                }
        }
        
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 150{
            if scrollView.contentOffset.y < 0{
                collectionView.frame.origin.y = 148
            } else if scrollView.contentOffset.y > 50 {
                collectionView.frame.origin.y = 99
            } else {
                collectionView.frame.origin.y = 148 - scrollView.contentOffset.y
            }
        }
        
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 150{
            //&& ((!segmentedControlHidden && scrollingDown) || (segmentedControlHidden && !scrollingDown)) {
            if scrollView.contentOffset.y < 0 {
                self.segmentedControl.frame.origin.y = 20
                segmentedControlHidden = false
            } else if scrollView.contentOffset.y > 80 {
                self.segmentedControl.frame.origin.y = -80
                segmentedControlHidden = true
            } else {
                self.segmentedControl.frame.origin.y = 20 - (scrollView.contentOffset.y)
            }
        }
        
        
//        if scrollView.contentOffset.y > 300 && !scrollingDown && !middleZone && segmentedControlHidden {
//            middleZone = true
//            trackContentOffset = scrollView.contentOffset.y
//        }
//        
//        
//        if scrollView.contentOffset.y > 300 && scrollingDown && !middleZone && !segmentedControlHidden {
//            middleZone = true
//            trackContentOffset = scrollView.contentOffset.y
//        }
//        
//        if middleZone && !scrollingDown {
//            self.segmentedControl.frame.origin.y = -120 + (trackContentOffset-scrollView.contentOffset.y)
//            self.searchView.frame.origin.y = 20 + (trackContentOffset-scrollView.contentOffset.y)
//            if(trackContentOffset-scrollView.contentOffset.y) > 140{
//                middleZone = false
//                segmentedControlHidden = false
//                self.segmentedControl.frame.origin.y = 20
//                self.searchView.frame.origin.y = 77
//            }
//        }
//        if middleZone && scrollingDown {
//            self.segmentedControl.frame.origin.y = 20 + (trackContentOffset-scrollView.contentOffset.y)
//            self.searchView.frame.origin.y = 77 + (trackContentOffset-scrollView.contentOffset.y)
//            if(trackContentOffset-scrollView.contentOffset.y) < -100{
//                middleZone = false
//                segmentedControlHidden = true
//                self.segmentedControl.frame.origin.y = -80
//                self.searchView.frame.origin.y = 20
//            }
//        }
        
        lastContentOffset = scrollView.contentOffset.y
        //print(self.searchView.frame.origin.y)
        
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
        if shouldShowSearchResults{
            if let filteredDrinks = filteredDrinks{
                return filteredDrinks.count
            } else{
                return 0
            }
        } else{
            return drinks.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCell", forIndexPath: indexPath) as! DrinkCell
        
        if shouldShowSearchResults{
            cell.drink = filteredDrinks![indexPath.row]
        } else{
            cell.drink = drinks[indexPath.row]
        }
        
        return cell
    }
    
}
