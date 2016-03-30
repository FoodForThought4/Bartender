//
//  CreateViewController.swift
//  Bartendr
//
//  Created by Lainie Wright on 3/26/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
//    let ingredients = [["Brandy", "Gin", "Rum", "Tequila", "Vodka", "Whisky", "Vermouth"], ["Lemon Juice", "Lime Juice", "Cranberry Juice", "Pineapple Juice", "Orange Juice", "Tonic", "Grenadine", "Ginger Ale", "Cola"], ["Lime", "Lemon", "Orange", "Raspberry", "Strawberry", "Maraschino", "Pineapple"]]
    
    let ingredients = ["Brandy", "Gin", "Rum", "Tequila", "Vodka", "Whisky", "Vermouth", "Lemon Juice", "Lime Juice", "Cranberry Juice", "Pineapple Juice", "Orange Juice", "Tonic", "Grenadine", "Ginger Ale", "Cola", "Lime", "Lemon", "Orange", "Raspberry", "Strawberry", "Maraschino", "Pineapple"]
    
    var checkStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self;
        tableView.dataSource = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ingredients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CreateCell", forIndexPath: indexPath) as! CreateCell
        
        cell.nameLabel.text = ingredients[indexPath.row]
        cell.selectionStyle = .None
        cell.delegate = self
        
        cell.isSelected = checkStates[indexPath.row] ?? false
        
        if cell.isSelected == true {
            cell.checkBoxImageView.image = UIImage(named: "CheckBoxSelected")
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCellWithIdentifier("NameCell")! as UITableViewCell
        return footerView
    }
    
    func onPushCreate() {
        
        var ingredientList = [Ingredient]()
        for index in 0...checkStates.count {
            if checkStates[index] == true {
                ingredientList.append(Ingredient(ingredientData: ["text": ingredients[index]]))
            }
        }
        
        let name = "Another drink"
        let description = "description"
        let image = UIImage(named: "defaultDrink")
        
        let drink = Drink(name: name, description: description, customImg: image!, ingredients: ingredientList)
        
        
        ApiClient.createDrink(drink) { (success) in
            print("successfully created drink")
        }
        
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CreateCell
        
        cell.delegate?.createCell?(cell, didChangeValue: !cell.isSelected!)
        
        tableView.reloadData()
    }
    
    func createCell(createCell: CreateCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(createCell)
        
        checkStates[indexPath!.row] = value
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
