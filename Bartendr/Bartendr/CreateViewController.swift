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
    
    
    let ingredients = [["Brandy", "Gin", "Rum", "Tequila", "Vodka", "Whisky", "Vermouth"], ["Lemon Juice", "Lime Juice", "Orange Juice", "Cranberry Juice", "Pineapple Juice", "Tonic", "Grenadine", "Ginger Ale", "Cola"], ["Lime", "Lemon", "Orange", "Raspberry", "Strawberry", "Maraschino Berry", "Pineapple"]]
    
    let types = ["Brandy": "brandy", "Gin": "gin", "Rum": "rum", "Tequila": "tequila", "Vodka": "vodka", "Whisky": "whisky", "Vermouth": "spirits-other", "Lemon Juice": "mixers", "Lime Juice": "mixers", "Orange Juice": "mixers", "Cranberry Juice": "mixers", "Pineapple Juice": "mixers", "Tonic": "mixers", "Grenadine": "mixers", "Ginger Ale": "mixers", "Cola": "mixers", "Lime": "fruits", "Lemon": "fruits", "Orange": "fruits", "Raspberry": "fruits", "Strawberry": "fruits", "Maraschino Berry": "fruits", "Pineapple": "fruits"]
    
    var checkStates = [Int: Bool]()
    
    var selectedIngredients: [String] = []
    
    var editedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDismissed:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomView.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomLabel.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        photoButtonView.layer.cornerRadius = 10
        photoButtonView.clipsToBounds = true
        
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nameField.delegate = self
        
        let touch = UITapGestureRecognizer(target:self, action: "onPhotoSelect")
        photoButtonView.addGestureRecognizer(touch)
        
        tableView.rowHeight = 36
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCreate(sender: AnyObject) {
        print("clicked")
        let name = nameField.text! as String
        let description = "Mix these ingredients together and enjoy!"
        
        var image: UIImage
        if editedImage == nil {
            image = UIImage(named: "defaultDrink")!
        }
        else {
            image = editedImage
        }
        
        var ingredientList = [Ingredient]()
        for ingredient in selectedIngredients {
            ingredientList.append(Ingredient(id: ApiClient.generateId(), text: ingredient))
        }
        
        let drink = Drink(name: name, description: description, customImg: image, ingredients: ingredientList)
        
        ApiClient.createDrink(drink) { (success) in
            if success {
                let barViewControllers = self.tabBarController?.viewControllers
                let vc = barViewControllers![0] as! RecipesViewController
                vc.drinks.insert(drink, atIndex: 0)
                self.tabBarController?.selectedIndex = 0
                vc.collectionView.reloadData()
                print("successfully created drink")
            } else {
                print("error creating drink")
            }
            self.nameField.text = ""
            self.nameField.placeholder = "Add a boozy name"
            for (i, _) in self.checkStates {
                self.checkStates[i] = false
            }
        }
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
  
        cell.nameLabel.text = ingredients[indexPath.section][indexPath.row]
        cell.selectionStyle = .None

        if checkStates[10*indexPath.section + indexPath.row] == true {
            cell.checkBoxImageView.image = UIImage(named: "CheckBoxSelected")
            cell.amountSelectorView.hidden = false
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
            cell.amountSelectorView.hidden = true
            
        }
        
        if indexPath.row == 0{
            cell.round([UIRectCorner.TopLeft, UIRectCorner.TopRight], radius: 14)
        } else {
            cell.round([UIRectCorner.TopLeft, UIRectCorner.TopRight], radius: 0)
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
        footerView!.round([UIRectCorner.BottomLeft, UIRectCorner.BottomRight], radius: 14)
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
            cell.isSelected = true
            cell.amountSelectorView.hidden = false
            checkStates[10*indexPath.section + indexPath.row] = true
            if selectedIngredients.indexOf(cell.nameLabel.text!) == nil{
                selectedIngredients.append(cell.nameLabel.text!)
            }
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
            cell.isSelected = false
            cell.amountSelectorView.hidden = true
            checkStates[10*indexPath.section + indexPath.row] = false
            cell.amountField.text = "0"
            cell.amount = 0
            if selectedIngredients.indexOf(cell.nameLabel.text!) != nil{
                selectedIngredients.removeAtIndex(selectedIngredients.indexOf(cell.nameLabel.text!)!)
            }
        }
        
        tableView.reloadData()
    }
    
    func onPhotoSelect() {
        print("clicked")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        //        vc.sourceType = UIImagePickerControllerSourceType.Camera // use for pics from camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            vc.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

extension CreateViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
//        challengeImageView.image = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CreateViewController: UINavigationControllerDelegate {
        
}



