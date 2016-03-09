//
//  CreateDrinkViewController.swift
//  Bartendr
//
//  Created by Lainie Wright on 3/8/16.
//  Copyright © 2016 Bartendr. All rights reserved.
//

import UIKit

class CreateDrinkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var spiritsTableView: UITableView!
    @IBOutlet weak var mixersTableView: UITableView!
    @IBOutlet weak var fruitsTableView: UITableView!
    
    var spirits = ["Brandy", "Gin", "Rum", "Tequila", "Vodka", "Whisky", "Vermouth"]
    
    var mixers = ["Lemon Juice", "Lime Juice", "Cranberry Juice", "Pineapple Juice", "Orange Juice", "Tonic", "Grenadine", "Ginger Ale", "Cola"]
    
    var fruits = ["Lime", "Lemon", "Orange", "Raspberry", "Strawberry", "Maraschino", "Pineapple"]

    override func viewDidLoad() {
        super.viewDidLoad()
        spiritsTableView.dataSource = self
        spiritsTableView.delegate = self
        mixersTableView.dataSource = self
        mixersTableView.delegate = self
        fruitsTableView.dataSource = self
        fruitsTableView.delegate = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.spiritsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("SpiritCell", forIndexPath: indexPath)
            let label = UILabel(frame: CGRectMake(10.0, 0.0, 220, 25.0))
            label.text = spirits[indexPath.row]
            cell?.contentView.addSubview(label)
            spiritsTableView.reloadData()
        }
        
        if tableView == self.mixersTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("MixerCell", forIndexPath: indexPath)
            let label = UILabel()
            label.text = mixers[indexPath.row]
            cell?.addSubview(label)
            mixersTableView.reloadData()
        }
        
        if tableView == self.fruitsTableView {
            cell = tableView.dequeueReusableCellWithIdentifier("FruitCell", forIndexPath: indexPath)
            let label = UILabel()
            label.text = mixers[indexPath.row]
            cell?.addSubview(label)
            fruitsTableView.reloadData()
        }
        
        return cell!
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
