//
//  RecipeViewController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/22/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeSearchTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let spoonacularURL = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=5&ranking=1&ignorePantry=false&ingredients=apples%2Cpeanut+butter"

    //To add any other ingredients to the list, use the format %2C[name] to end of the query
    
    @IBOutlet weak var tableView: UITableView!
    var pantry: [FoodItem]? = []
    var recipeSearchService: Array<RecipeSearchService> = []
    
    var passedDiet: String = ""
    var passedCourse: String = ""
    var passedCuisine: String = ""
    var passedInstruction: String = ""
    var passedDishName: String = ""
    

    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        super.viewDidLoad()
        
        var spoonacularURL2 = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?"
        print("Length of string")
        print(spoonacularURL2.count) //diet=vegetarian&excludeIngredients=coconut&intolerances=egg%2C+gluten&number=10&offset=0&type=main+course&instructionsRequired=true&query=burger
        if passedCuisine != "N/A"{
            spoonacularURL2 = spoonacularURL2 + "cuisine=" + passedCuisine
        }
        if passedDiet != "N/A"{
            spoonacularURL2 = spoonacularURL2 + "diet=" + passedDiet
        }
        if passedCourse != "N/A"{
            passedCourse = passedCourse.replacingOccurrences(of: " ", with: "+")
            spoonacularURL2 = spoonacularURL2 + "&type=" + passedCourse
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        
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
                    self.recipeSearchService = try decoder.decode(Array<RecipeSearchService>.self, from: data)
                    
                    print("PRINT DATA")
                    print(self.recipeSearchService)
                    print(type(of: self.recipeSearchService))
                }
                catch {
                    print("Exception on Decode: \(error)")
                }
                
            }
            self.recipeSearchService =  self.recipeSearchService.sorted(by: { $0.missedIngredientCount < $1.missedIngredientCount })
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        
        spoonTask.resume()
        
    }
    
    
    
    /*
     
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     
     return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return self.ourPantry.count
     
     }
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count here")
        print(self.recipeSearchService.count)
        return  self.recipeSearchService.count// your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCell
        
        // Configure the cell...
        /*
         @IBOutlet weak var nameLabel: UILabel!
         @IBOutlet weak var quantityLabel: UILabel!
         @IBOutlet weak var expiryLabel: UILabel!
         @IBOutlet weak var unitLabel: UILabel!
         */
        let thisItem = self.recipeSearchService[indexPath.row]
        cell?.recipeName?.text = thisItem.title
        cell?.missingLabel?.text = String(thisItem.missedIngredientCount)
        
        //cell?.recipeImage.image = [UIImage imageWithContentsOfURL:thisItem.image]
        print("title api")
        print(thisItem.title)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showSelectedRecipe" {
            let destVC = segue.destination as? RecipeDetail
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.passedRecipe = self.recipeSearchService[(selectedIndexPath?.row)!]
        }
        
    }
    
    @IBAction func unwindFromRecipeDetail(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func unwindFromRecipeSort(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
    
    
}