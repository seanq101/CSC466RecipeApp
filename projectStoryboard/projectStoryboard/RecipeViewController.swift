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
            print(type(of: receivedData))
            let theString:NSString = NSString(data: receivedData!, encoding: String.Encoding.ascii.rawValue)!
            print(theString)
            //print(receivedData! as NSData)
            if let data = receivedData {
                var jsonResponse : [String:AnyObject]?
                
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    print("jsonResponse type: \(type(of: jsonResponse))")
                }
                catch {
                    print("Caught exception")
                }
                print("data")
                print(jsonResponse)
                
                //print(jsonResponse?["root"]?["stations"] ?? "none")
                //var json = jsonResponse
                
                
               
                
            }
        }
        spoonTask.resume()
        
    }
}
