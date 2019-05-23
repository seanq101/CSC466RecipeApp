//
//  RecipeViewController.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/22/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    let spoonacularURL = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?number=5&ranking=1&ignorePantry=false&ingredients=apples%2Cflour%2Csugar"

    
    var pantry: [FoodItem]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    let recipeSearchService = try decoder.decode(Array<RecipeSearchService>.self, from: data)
                    
                    print("PRINT DATA")
                    print(recipeSearchService)
                }
                catch {
                    print("Exception on Decode: \(error)")
                }
     
            }
        }
        spoonTask.resume()
        
    }
}
