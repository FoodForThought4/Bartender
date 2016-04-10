//
//  CreateViewController.swift
//  Bartendr
//
//  Created by Lainie Wright on 3/26/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var photoButtonView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    var drinkImage: UIImage!
    
    let ingredients = [[["name": "Brandy", "id": "brandy", "type": "brandy", "keyword": "Part"], ["name": "Gin", "id":"gin", "type": "gin", "keyword": "Part"], ["name:": "Rum", "id": "rum", "type": "rum", "keyword": "Part"], ["name": "Tequila", "id": "tequila", "type": "tequila", "keyword": "Part"], ["name": "Vodka", "id": "vodka", "type": "vodka", "keyword": "Part"], ["name": "Whisky", "id": "whisky", "type": "whisky", "keyword": "Part"], ["name": "Vermouth", "id": "vodka", "type": "vodka", "keyword": "Part"]], [["name": "Lemon Juice", "id": "lemon-juice", "type": "mixers", "keyword": "Part"], ["name": "Lime Juice", "id": "lime-juice", "type": "mixers", "keyword": "Part"], ["name": "Cranberry Juice", "id": "cranberry-juice", "type": "mixers", "keyword": "Part"], ["name": "Pineapple Juice", "id": "pineapple-juice", "type": "mixers", "keyword": "Part"], ["name": "Orange Juice", "id": "orange-juice", "type": "mixers", "keyword": "Part"], ["name": "Tonic", "id": "tonic", "type": "mixers", "keyword": ""], ["name": "Grenadine", "id": "grenadine", "type": "mixers", "keyword": "Part"], ["name": "Ginger Ale", "id": "ginger-ale", "type": "mixers", "keyword": ""], ["name": "Cola", "id": "cola", "type": "mixers", "keyword": ""]], [["name": "Lime", "id": "lime", "type": "fruits", "keyword": "Twist"], ["name": "Lemon", "id": "lemon", "type": "fruist", "keyword": "Twist"], ["name": "Orange", "id": "orange", "type": "fruits", "keyword": "Peel"], ["name": "Raspberry", "id": "raspberry", "type": "fruits", "keyword": "Whole"], ["name": "Strawberry", "id": "strawberry", "type": "fruits", "keyword": "Whole"], ["name": "Maraschino Berry", "id": "maraschino-berry", "type": "fruits", "keyword": "Whole"]]]
    
    var selectedIngredients: [NSDictonary]!
    
    var checkStates = [[Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDismissed:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomView.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomLabel.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        photoButtonView.layer.cornerRadius = 4
        photoButtonView.clipsToBounds = true
        
        createButton.layer.cornerRadius = 4
        createButton.clipsToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
        
        nameField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCreate(sender: AnyObject) {
        let name = nameField.text! as String
        let description = "These are the instructions for making the drink."
        var image: UIImage
        
        if drinkImage != nil {
            image = drinkImage
        } else {
            image = UIImage(named: "defaultDrink")!
        }
        
        var ingredients = [Ingredient]()
        for ingredient in selectedIngredients {
            let text = ingredient.keyword + ingredient.name
            ingredients.append(Ingredient(id: ingredient.id, text: ingredient.text, type: ingredient.type))
        }
        
        let drink = Drink(name: name, description: description, customImg: image, ingredients: ingredients)
        
        ApiClient.createDrink(drink) { (success) in
            if success {
                let barViewControllers = self.tabBarController?.viewControllers
                let vc = barViewControllers![0] as! RecipesViewController
                vc.drinks.insert(drink, atIndex: 0)
                vc.collectionView.reloadData()
                self.tabBarController?.selectedIndex = 0
                print("successfully created drink")
            } else {
                print("error creating drink")
            }
        }
        
        drinkImage = nil
        nameField.text = ""
        nameField.placeholder = "Add a boozy name"
        
    }

    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Scroll down to height of text box, animated
        NSNotificationCenter.defaultCenter().postNotificationName("KeyboardShown", object: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
    
    func keyboardShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.bottomConstraint.constant = 0.0
            } else {
                self.bottomConstraint.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
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

extension CreateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ingredients.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! IngredientCell
  
        cell.nameLabel.text = ingredients[indexPath.section][indexPath.row]["name"]
        cell.selectionStyle = .None
        //cell.isSelected = checkStates[indexPath.section][indexPath.row] ?? false
        ingredients[indexPath.section][indexPath.row]["amount"] = cell.amount

        if indexPath.row == 0{
            //cell.round([UIRectCorner.TopLeft, UIRectCorner.TopRight], radius: 8)
        } else {
            //cell.round([UIRectCorner.TopLeft, UIRectCorner.TopRight], radius: 0)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCellWithIdentifier("SectionHeader")
        headerView!.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        let label = headerView?.viewWithTag(456) as! UILabel
        
        if section == 0 {
            label.text = "Spirits"
        } else if section == 1 {
            label.text = "Fruits and Mixers"
        } else {
            label.text = "Other"
        }
        
        return headerView
    }

    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCellWithIdentifier("AddIngredientCell")
        footerView!.frame.size.width = tableView.frame.width
        //footerView!.round([UIRectCorner.BottomLeft, UIRectCorner.BottomRight], radius: 8)
        return footerView
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let height = CGFloat(44)
        return height
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = CGFloat(44)
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! IngredientCell
        
        if(cell.isSelected == false){
            cell.checkBoxImageView.image = UIImage(named: "CheckBoxSelected")
            cell.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
            cell.isSelected = true
            //checkStates[indexPath.section][indexPath.row] = true
            if selectedIngredients.indexOf(cell.nameLabel.text!) == nil{
                selectedIngredients.append(cell.nameLabel.text!)
            }
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
            cell.backgroundColor = UIColor.whiteColor()
            cell.isSelected = false
            //checkStates[indexPath.section][indexPath.row] = false
            cell.amountField.text = "0"
            cell.amount = 0
            if selectedIngredients.indexOf(cell.nameLabel.text!) != nil{
                selectedIngredients.removeAtIndex(selectedIngredients.indexOf(cell.nameLabel.text!)!)
            }
        }
        
        tableView.reloadData()
    }
}

extension CreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBAction func selectImageFromPhotoLibrary(sender: AnyObject) {
        nameField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        drinkImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
}





