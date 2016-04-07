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

    
    let ingredients = Ingredient.TYPES
    
    var selectedIngredients: [String] = []
    
    var checkStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateViewController.keyboardShown(_:)), name: "KeyboardShown", object: nil)
        
        self.view.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomView.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        bottomLabel.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        
        photoButtonView.layer.cornerRadius = 4
        photoButtonView.clipsToBounds = true
        
        createButton.layer.cornerRadius = 4
        createButton.clipsToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onCreate(sender: AnyObject) {
        let name = nameField.text! as String
        let description = "description"
        let image = UIImage(named: "defaultDrink")
        
        var ingredientList = [Ingredient]()
        for ingredient in selectedIngredients {
            ingredientList.append(Ingredient(ingredientData: ["text" : ingredient]))
        }
        
        let drink = Drink(name: name, description: description, customImg: image!, ingredients: ingredientList)
        
        
        ApiClient.createDrink(drink) { (success) in
            print("successfully created drink")
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        nameField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Scroll down to height of text box, animated
        NSNotificationCenter.defaultCenter().postNotificationName("KeyboardShown", object: nil)
        print("yo")
//        UIView.animateWithDuration(0.3, animations: {
//            <#code#>
//            }) { (<#Bool#>) in
//                <#code#>
//        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Restore
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        print("keyboardFrame: \(keyboardFrame)")
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
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCellWithIdentifier("SectionHeader")
        headerView!.backgroundColor = UIColor(red: 241/255, green: 246/255, blue: 241/255, alpha: 1)
        let label = headerView?.viewWithTag(456) as! UILabel
        let imageView = headerView?.viewWithTag(789) as! UIImageView
        
        if section == 0 {
            label.text = "Spirits"
        } else if section == 1 {
            label.text = "Fruits and Mixers"
        } else {
            label.text = "Other"
        }
        
        imageView.frame.size.width = label.frame.size.width
        
        return headerView
    }

    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCellWithIdentifier("AddIngredientCell")
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
            if selectedIngredients.indexOf(cell.nameLabel.text!) == nil{
                selectedIngredients.append(cell.nameLabel.text!)
            }
        } else {
            cell.checkBoxImageView.image = UIImage(named: "CheckBox")
            cell.backgroundColor = UIColor.whiteColor()
            cell.isSelected = false
            cell.amountField.text = "0"
            cell.amount = 0
            if selectedIngredients.indexOf(cell.nameLabel.text!) != nil{
                selectedIngredients.removeAtIndex(selectedIngredients.indexOf(cell.nameLabel.text!)!)
            }
        }
        
        tableView.reloadData()
    }
}

