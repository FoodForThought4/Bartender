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
    @IBOutlet weak var tableView: UITableView!
    
    var drinks = [Drink]()
    var filteredDrinks = [Drink]()
//    let ingredients = ["Brandy", "Gin", "Rum", "Tequila", "Vodka", "Whisky", "Vermouth", "Lemon Juice", "Lime Juice", "Cranberry Juice", "Pineapple Juice", "Orange Juice", "Tonic", "Grenadine", "Ginger Ale", "Cola", "Lime", "Lemon", "Orange", "Raspberry", "Strawberry", "Maraschino", "Pineapple"]
    let ingredients = Ingredient.TYPES
    
    var selectedIngredients: [String] = []
    
    var currentView = 0
    var isMoreDataLoading = false
    var atBottomThreshold = false
    
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
        setupTableView()
        
        configureCustomSearchController()
        
        getDrinks(false)
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
        
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RecipesViewController.swipeLeft))
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RecipesViewController.swipeRight))
//        
//        leftSwipe.direction = .Left
//        rightSwipe.direction = .Right
//        
//        collectionView.addGestureRecognizer(leftSwipe)
//        collectionView.addGestureRecognizer(rightSwipe)
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.hidden = true
        tableView.frame.origin.x = 400
    }
    
//    func swipeLeft(){
//        //segmentedControl.selectedSegment = 1
//        print("1")
//    }
//    
//    func swipeRight(){
//        //segmentedControl.selectedSegment = 0
//        print("0")
//        
//    }
    
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
        ApiClient.getDrinksADDB(selectedIngredients, nextPage: nextPage) { (drinkData, error) -> () in
            if error != nil{
                print("error")
            } else {
                if nextPage {
                    self.drinks += drinkData!
                    self.filteredDrinks += drinkData!
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
    
    func didChangeSearchText(searchText: String) {
        // Filter the data array and get only those countries that match the search text.
        if searchText.isEmpty{
            shouldShowSearchResults = false
        } else {
            
            let newSearchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "/")
            ApiClient.searchDrinkADDB(newSearchText, nextPage: false, completion: { (drinkData, error) -> () in
                if error == nil {
                    print("success!")
                    self.filteredDrinks = drinkData!
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
            self.collectionView.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.frame.origin.x = 400
                self.collectionView.frame.origin.x = 0
                self.searchView.frame.origin.x = 30
                },  completion: { finished in
                    if (finished) {
                        self.tableView.hidden = true
                    }
            })
            currentView = 0
            print("this is page 1")
            getDrinks(false)
            
            
            
        } else if selectedSegment == 1 && currentView != 1{
            tableView.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.frame.origin.x = 20
                self.collectionView.frame.origin.x = -400
                self.searchView.frame.origin.x = -370
                },  completion: { finished in
                    if (finished) {
                        self.collectionView.hidden = true
                    }
            })
            currentView = 1
        }
    }
}


extension RecipesViewController: UICollectionViewDelegate {
    func animateHeader(scrollView: UIScrollView){
        let scrollViewContentHeight = scrollView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - scrollView.bounds.size.height
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y + 20 > scrollOffsetThreshold){
            atBottomThreshold = true
        } else {
            atBottomThreshold = false
        }
        //tracking if user is scrolling down or up
        if scrollView.contentOffset.y > lastContentOffset && scrollView.contentOffset.y > 0 {
            scrollingDown = true
        }
        if scrollView.contentOffset.y < lastContentOffset && scrollView.contentOffset.y > 0 {
            scrollingDown = false
        }
        
        //tracks switch directions while scrolling
        if scrollView.contentOffset.y > 500 && !scrollingDown && !middleZone && segmentedControlHidden {
            middleZone = true
            trackContentOffset = scrollView.contentOffset.y
        }
        
        
        if scrollView.contentOffset.y > 500 && scrollingDown && !middleZone && !segmentedControlHidden {
            middleZone = true
            trackContentOffset = scrollView.contentOffset.y
        }
        
        //search movement animation
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 250
            && ((!segmentedControlHidden && scrollingDown) || (segmentedControlHidden && !scrollingDown)) {
                if scrollView.contentOffset.y < 0 {
                    self.searchView.frame.origin.y = 77
                } else if scrollView.contentOffset.y > 40 {
                    self.searchView.frame.origin.y = 38
                } else {
                    self.searchView.frame.origin.y = 77 - (scrollView.contentOffset.y)
                }
        }
        
        //collection view movement animation
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 250
            && ((!segmentedControlHidden && scrollingDown) || (segmentedControlHidden && !scrollingDown)) {
                if scrollView.contentOffset.y < 0{
                    collectionView.frame.origin.y = 148
                } else if scrollView.contentOffset.y > 50 {
                    collectionView.frame.origin.y = 99
                } else {
                    collectionView.frame.origin.y = 148 - scrollView.contentOffset.y
                }
        }
        
        //hiding and showing segmentedControl when reaching the top of the scrollView
        if scrollView.contentOffset.y > -50 && scrollView.contentOffset.y < 250
            && ((!segmentedControlHidden && scrollingDown) || (segmentedControlHidden && !scrollingDown)) {
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
        
        if middleZone && !scrollingDown && !atBottomThreshold{
            if (trackContentOffset-scrollView.contentOffset.y) < 100 {
                self.segmentedControl.frame.origin.y = -80 + (trackContentOffset-scrollView.contentOffset.y)
                if (trackContentOffset-scrollView.contentOffset.y) < 40 {
                    self.searchView.frame.origin.y = 38 + (trackContentOffset-scrollView.contentOffset.y)
                } else {
                    self.searchView.frame.origin.y = 77
                }
                
                if (trackContentOffset-scrollView.contentOffset.y) < 50 {
                    collectionView.frame.origin.y = 99 + (trackContentOffset-scrollView.contentOffset.y)
                } else {
                    collectionView.frame.origin.y = 148
                }
            } else {
                middleZone = false
                segmentedControlHidden = false
                self.segmentedControl.frame.origin.y = 20
            }
        }
        
        if middleZone && scrollingDown && !atBottomThreshold{
            if (trackContentOffset-scrollView.contentOffset.y) > -100 {
                self.segmentedControl.frame.origin.y = 20 + (trackContentOffset-scrollView.contentOffset.y)
                if (trackContentOffset-scrollView.contentOffset.y) > -40 {
                    self.searchView.frame.origin.y = 77 + (trackContentOffset-scrollView.contentOffset.y)
                } else {
                    self.searchView.frame.origin.y = 38
                }
                
                if (trackContentOffset-scrollView.contentOffset.y) > -50 {
                    collectionView.frame.origin.y = 148 + (trackContentOffset-scrollView.contentOffset.y)
                } else {
                    collectionView.frame.origin.y = 99
                }
            } else {
                middleZone = false
                segmentedControlHidden = true
                self.segmentedControl.frame.origin.y = -80
            }
        }
        
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        animateHeader(scrollView)
        
        //fading in cells
        for cell in collectionView.visibleCells() as [UICollectionViewCell] {
            
            let point = collectionView.convertPoint(cell.center, toView: collectionView.superview)
            cell.alpha = (point.y - 80) / 50
        }
        
        // paging for fetching new data
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = scrollView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - scrollView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y + 80 > scrollOffsetThreshold && scrollView.dragging) {
                
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
            return filteredDrinks.count
        } else{
            return drinks.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCell", forIndexPath: indexPath) as! DrinkCell
            
        if shouldShowSearchResults{
            cell.drink = filteredDrinks[indexPath.row]
        } else{
            cell.drink = drinks[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if shouldShowSearchResults{
            self.performSegueWithIdentifier("DetailViewSegue", sender: filteredDrinks[indexPath.row])
        } else{
            self.performSegueWithIdentifier("DetailViewSegue", sender: drinks[indexPath.row])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailViewSegue"{
            let viewController  = segue.destinationViewController as! DetailViewController
            let drink = sender as! Drink
            viewController.drink = drink
        }
    }
    
}

extension RecipesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ingredients.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! IngredientCell
        
        cell.nameLabel.text = ingredients[indexPath.section][indexPath.row]
        //cell.isSelected = false
        cell.selectionStyle = .None
        
        return cell
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Spirits"
//        } else if section == 1 {
//            return "Fruits and Mixers"
//        } else {
//            return "Other"
//        }
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCellWithIdentifier("SectionHeader")
        let label = headerView?.viewWithTag(123) as! UILabel
        if section == 0 {
            label.text = "Spirits"
        } else if section == 1 {
            label.text = "Fruits and Mixers"
        } else {
            label.text = "Other"
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = CGFloat(44)
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientCell
        
        if(cell.isSelected == false){
            cell.checkBoxImageView.image = UIImage(named: "CheckBoxSelected")
            cell.isSelected = true
            if selectedIngredients.indexOf(cell.nameLabel.text!) == nil{
                selectedIngredients.append(cell.nameLabel.text!)
            }
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
            cell.isSelected = false
            if selectedIngredients.indexOf(cell.nameLabel.text!) != nil{
                selectedIngredients.removeAtIndex(selectedIngredients.indexOf(cell.nameLabel.text!)!)
            }
        }
        
        tableView.reloadData()
    }
}
