//
//  RecipeDetail.swift
//  projectStoryboard
//
//  Copyright © 2019 Andrew Puleo. All rights reserved.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeDetail: UIViewController{
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lngredientsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var passedRecipe: RecipeSearchService?
    let spoonacularURL1 = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
    let spoonacularURL2 = "/information?includeNutrition=false"
    
    var instructionSearchService: InstructionSearchService?
    override func viewDidLoad() {
        
        let recipePicURL = URL(string: (self.passedRecipe?.image)!)!
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: recipePicURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async { // Make sure you're on the main thread here
                            let image = UIImage(data: imageData)
                            // Do something with your image.
                            self.recipeImage.image = image
                        }
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        let amount:Int? = passedRecipe?.id
        var spoonacularFinishedURL = ""
        if let tempId = amount{
            spoonacularFinishedURL = spoonacularURL1 + String(tempId) + spoonacularURL2
        }
        var spoonRequest = URLRequest(url: URL(string: spoonacularFinishedURL)!)
        spoonRequest.setValue("282dc9c01amsh58247426577f9a7p1776a9jsn132cf0e412e0", forHTTPHeaderField: "X-RapidAPI-Key")
        //X-RapidAPI-Host", "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        spoonRequest.setValue("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        let spoonTask: URLSessionDataTask = session.dataTask(with: spoonRequest)
        { [unowned self] (receivedData, response, error) -> Void in
            if let data = receivedData {
                do {
                    print("data was: ", data)
                    let decoder = JSONDecoder() // get a decoder
                    // decode based on the structure [RecipeSearchService]
                    // change RecipeSearchService as needed to shapeof response
                    self.instructionSearchService = try decoder.decode(InstructionSearchService.self, from: data)
                    
                    print("PRINT DATA")
                    print(self.instructionSearchService)
                    print(type(of: self.instructionSearchService))
                    
                }
                catch {
                    print("Exception on Decode: \(error)")
                }
                
            }
            DispatchQueue.main.async{
                if let instructions = self.instructionSearchService?.instructions{
                    self.directionsLabel.text = self.directionsLabel.text! + instructions
                }
                
            }
        }
        
        spoonTask.resume()
        
        
        
        self.nameLabel.text = passedRecipe?.title
        let likes = String(describing: (passedRecipe?.likes)!)
        self.likesLabel.text = self.likesLabel.text! + " " + likes
        //self.lngredientsLabel.text = passedRecipe.
//        print(type(of: self.passedRecipe?.missedIngredients))
//        print(self.passedRecipe?.missedIngredients)
        let missedArray = self.passedRecipe?.missedIngredients as! Array<Any>
        var count = 0
        for ingredient in missedArray{
            let theIngredient = ingredient as! RecipeSearchService.Ingredient
            print(theIngredient.originalName)
            if count != 0 {
                self.lngredientsLabel.text = self.lngredientsLabel.text! + ", " + theIngredient.originalName
            }else{
                self.lngredientsLabel.text = self.lngredientsLabel.text! + " " + theIngredient.originalName
            }
            count += 1
            //print(type(of: ingredient["originalName"]))
        }
        
        /*
         
         InstructionSearchService
         
         struct Ingredient : Codable {
         let id : Int
         let amount : Float
         let unitLong : String
         let originalName : String
         let image : String
         }
         */
    }
    
}
