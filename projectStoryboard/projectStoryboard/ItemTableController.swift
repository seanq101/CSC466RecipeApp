//
//  ItemTableController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/21/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//
import os.log
import UIKit

class ItemTableController: UITableViewController {
    var ourPantry = [FoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedFoodItems = loadFoodItems() {
            ourPantry += savedFoodItems
        }
//        let properName: String
//        let apiName: String
//        let quantity: Int
//        let unit: String
//        let expiry: Date
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        let dateOne = formatter.date(from: "2019/06/01")
//        ourPantry.append(FoodItem(properName: "Wheat Bread", apiName: "bread", quantity: 2, unit: "slices", expiry: dateOne! ))

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
        
        
        
        return cell!
    }
    
    
    @IBAction func sendFoodItem(_ unwindSegue: UIStoryboardSegue) {
        guard let speechVC = unwindSegue.source as? speechInputViewController,
        let foodItem = speechVC.foodItem else {
                return
        }
        ourPantry.append(foodItem)
        //print(foodItem)
//        let newIndexPath = IndexPath(row: ourPantry.count, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        saveFoodItems()
    }

    @IBAction func sendFoodItemFromBarcode(_ unwindSegue: UIStoryboardSegue) {
        guard let barcodeVC = unwindSegue.source as? BarcodeVC,
            let foodItem = barcodeVC.foodItem else {
                print("return early")
                return
        }
        print(foodItem)
        ourPantry.append(foodItem)
        //print(foodItem)
        //        let newIndexPath = IndexPath(row: ourPantry.count, section: 0)
        //        tableView.insertRows(at: [newIndexPath], with: .automatic)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        saveFoodItems()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.ourPantry.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveFoodItems()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    private func saveFoodItems() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ourPantry, toFile: FoodItem.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recipes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save recipes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadFoodItems() -> [FoodItem]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FoodItem.ArchiveURL.path) as? [FoodItem]
    }
    
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
    
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editFoodItemCell" {
            let destVC = segue.destination as? EditFoodItemDetail
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.passedFoodItem = self.ourPantry[(selectedIndexPath?.row)!]
        }
    }
    
    @IBAction func unwindCancelFromEditFoodItem(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindSaveFromEditFoodItem(_ unwindSegue: UIStoryboardSegue) {
        saveFoodItems()
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
}
