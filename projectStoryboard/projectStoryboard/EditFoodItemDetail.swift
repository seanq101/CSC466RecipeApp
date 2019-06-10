//
//  CustomRecipeSearchDetail.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 6/9/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class EditFoodItemDetail: UIViewController {
   
    @IBOutlet weak var originalNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quanitityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    var passedFoodItem: FoodItem?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.originalNameLabel.text = passedFoodItem?.properName
        self.nameTextField.text = passedFoodItem?.properName
        if let quant = passedFoodItem?.quantity{
            self.quanitityTextField.text = String(quant)
        }
        self.unitTextField.text = passedFoodItem?.unit
        self.dateTextField.text = passedFoodItem?.expiry.description
    
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        passedFoodItem?.properName = nameTextField.text!
        passedFoodItem?.quantity = Int(quanitityTextField.text!)!
        passedFoodItem?.unit = unitTextField.text!
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX

        if let chosenDate2 = dateFormatter2.date(from:dateTextField.text!){
            passedFoodItem?.expiry = chosenDate2
        }
        
        if let chosenDate = dateFormatter1.date(from:dateTextField.text!){
            passedFoodItem?.expiry = chosenDate
        }
        
        
//        if segue.identifier == "editFoodItemCell" {
//            let destVC = segue.destination as? EditFoodItemDetail
//            let selectedIndexPath = tableView.indexPathForSelectedRow
//            destVC?.passedFoodItem = self.ourPantry[(selectedIndexPath?.row)!]
//        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
