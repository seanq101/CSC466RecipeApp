//
//  ItemTableController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/21/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class ItemTableController: UITableViewController {
    var ourPantry = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let properName: String
//        let apiName: String
//        let quantity: Int
//        let unit: String
//        let expiry: Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateOne = formatter.date(from: "2019/06/01")
        ourPantry.append(FoodItem(properName: "Wheat Bread", apiName: "bread", quantity: 2, unit: "slices", expiry: dateOne! ))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ourPantry.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // #warning Incomplete implementation, return the number of rows
        print(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as? FoodItemCell

        // Configure the cell...
        /*
         @IBOutlet weak var nameLabel: UILabel!
         @IBOutlet weak var quantityLabel: UILabel!
         @IBOutlet weak var expiryLabel: UILabel!
         @IBOutlet weak var unitLabel: UILabel!
         */
        let thisItem = ourPantry[indexPath.row]
        cell?.nameLabel?.text = thisItem.properName
        cell?.quantityLabel?.text = thisItem.quantity.description
        cell?.expiryLabel.text = thisItem.expiry.description
        cell?.unitLabel.text = thisItem.unit
        
        print("row num")
        
        
        return cell!
    }
    
    
    @IBAction func sendFoodItem(_ unwindSegue: UIStoryboardSegue) {
        print("here")
        guard let speechVC = unwindSegue.source as? speechInputViewController,
        let foodItem = speechVC.foodItem else {
                return
        }
        ourPantry.append(foodItem)
        print("our pantry")
        print(ourPantry)
        //print(foodItem)
//        let newIndexPath = IndexPath(row: ourPantry.count, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
        DispatchQueue.main.async{
            self.tableView.reloadData()
            print("hi")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
