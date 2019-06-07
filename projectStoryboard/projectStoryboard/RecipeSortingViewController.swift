//
//  RecipeSortingViewController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 6/3/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeSortingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{


    @IBOutlet weak var dishNameField: UITextField!
    @IBOutlet weak var cuisinePicker: UIPickerView!
    @IBOutlet weak var coursePicker: UIPickerView!
    @IBOutlet weak var dietPicker: UIPickerView!
    @IBOutlet weak var instructionSwitch: UISwitch!
    
    var cuisines = [String]()
    var courses = [String]()
    var diets = [String]()
    

    // MARK: - UIPickerViewDataSource Methods
    
    // return number of columns/wheels
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == cuisinePicker {
            return self.cuisines.count
        }else if pickerView == coursePicker {
            return self.courses.count
        }else{
            return self.diets.count
        }
        
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == cuisinePicker {
            return self.cuisines[row]
        } else if pickerView == coursePicker {
            return self.courses[row]
        }else{
            return self.diets[row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cuisines = ["N/A","African","British","Chinese","French","Japanese","Korean","Vietnamese","Thai","Indian","Irish","Italian","Mexican","Spanish","Middle Eastern","Jewish","American","Cajun","Southern","Greek","German","Nordic","Eastern European","caribbean","Latin American"]
        

        self.courses = ["N/A","main course","side dish","dessert","appetizer","salad","bread","breakfast","soup","beverage","sauce","drink"]
        self.diets = ["N/A","pescetarian","vegetarian","vegan","lacto vegetarian","ovo vegetarian"]
        print(cuisines.count)
        cuisinePicker.dataSource = self
        cuisinePicker.delegate = self
        coursePicker.dataSource = self
        coursePicker.delegate = self
        dietPicker.dataSource = self
        dietPicker.delegate = self
        
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let chosenCuisine = cuisines[cuisinePicker.selectedRow(inComponent: 0)]
        print(chosenCuisine)
        let chosenCourse = courses[coursePicker.selectedRow(inComponent: 0)]
        print(chosenCourse)
        let chosenDiet = diets[dietPicker.selectedRow(inComponent: 0)]
        print(chosenDiet)
        //
        let includeInstructions = instructionSwitch.isOn
        print(includeInstructions)
        if segue.identifier == "sendToCustomRecipe" {
            let destVC = segue.destination as? RecipeDetail
            //let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.passedRecipe = nil//self.recipeSearchService[(selectedIndexPath?.row)!]
        }

        
    }
}
