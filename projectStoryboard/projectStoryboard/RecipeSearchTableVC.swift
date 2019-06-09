//
//  RecipeViewController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/22/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeSearchTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var complexRecipeSearchService : ComplexRecipeSearchService? = nil
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    var passedDishName: String?
    var passedCuisine: String?
    var passedCourse: String?
    var passedDiet: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        //unirest.get("https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex?query=burger&cuisine=american&diet=vegan&type=main+course&ranking=2&limitLicense=false&offset=0&number=10")

        
        let spoonURL1 = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/searchComplex?"
        
        let querySection = "query=" + passedDishName!
        print("querySection: ",querySection)
        var cuisineSection: String = ""
        
        if let cuisineChoice = passedCuisine {
            if cuisineChoice != "N/A"{
                cuisineSection = "&cuisine=" + cuisineChoice
            }
        }
        print("cuisineSection: ", cuisineSection)
        var dietSection: String = ""
        if let dietChoice = passedDiet{
            if dietChoice != "N/A"{
                dietSection = "&diet=" + dietChoice
            }
        }
        print("dietSection: ", dietSection)
        var courseSection: String = ""
        if let courseChoice = passedCourse{
            if courseChoice != "N/A"{
                let choiceList = courseChoice.split(separator: " ")
                
                courseSection = "&type="
                for sec in choiceList{
                    courseSection += sec + "+"
                }
                courseSection = String(courseSection.dropLast())
            }
        }
        print("courseSection: ",courseSection)
        let spoonURL2 = "&instructionsRequired=true&ranking=2&limitLicense=false&offset=0&number=10"
        let spoonacularURL = spoonURL1+querySection+cuisineSection+dietSection+courseSection+spoonURL2
        print(spoonacularURL)
        var spoonRequest = URLRequest(url: URL(string: spoonacularURL)!)
        
        spoonRequest.setValue("282dc9c01amsh58247426577f9a7p1776a9jsn132cf0e412e0", forHTTPHeaderField: "X-RapidAPI-Key")
        //X-RapidAPI-Host", "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        spoonRequest.setValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        
        
        let spoonTask: URLSessionDataTask = session.dataTask(with: spoonRequest)
        { [unowned self] (receivedData, response, error) -> Void in
            if let data = receivedData {
                do {
                    let decoder = JSONDecoder() // get a decoder
                    
                    // decode based on the structure [RecipeSearchService]
                    // change RecipeSearchService as needed to shapeof response
                    self.complexRecipeSearchService = try decoder.decode(ComplexRecipeSearchService.self, from: data)
                    
                    print("PRINT DATA")
                    print(self.complexRecipeSearchService?.results)
                    print(type(of: self.complexRecipeSearchService))
                }
                catch {
                    print("Exception on Decode: \(error)")
                }
                
            }
//            self.complexRecipeSearchService =  self.complexRecipeSearchService.sorted(by: { $0.missedIngredientCount < $1.missedIngredientCount })
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        
        spoonTask.resume()
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count here")
        print(complexRecipeSearchService?.results.count)
        if let complex = complexRecipeSearchService{
            return complex.results.count
        }else{
            return 0
        }
        //return  self.complexRecipeSearchService?.results.count ?? 0// your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeSearchCell", for: indexPath) as? RecipeSearchCell
        
        // Configure the cell...
        /*
         @IBOutlet weak var nameLabel: UILabel!
         @IBOutlet weak var quantityLabel: UILabel!
         @IBOutlet weak var expiryLabel: UILabel!
         @IBOutlet weak var unitLabel: UILabel!
         */
        let thisItem = self.complexRecipeSearchService?.results[indexPath.row]
        cell?.recipeNameLabel?.text = thisItem!.title
        //cell?.missingLabel?.text = String(thisItem!.missedIngredientCount)
        
        //cell?.recipeImage.image = [UIImage imageWithContentsOfURL:thisItem.image]
        print("title api")
        print(thisItem!.title)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCustomRecipeDetail" {
            let destVC = segue.destination as? CustomRecipeSearchDetail
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.passedRecipe = self.complexRecipeSearchService?.results[(selectedIndexPath?.row)!]
        }
        
    }
    
    @IBAction func unwindFromCustomRecipeSearchDetail(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    
    
}
