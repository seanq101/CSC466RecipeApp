//
//  CustomRecipeSearchDetail.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 6/9/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class CustomRecipeSearchDetail: UIViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directionsLabel: UILabel!
    
    
    
    
    let spoonacularURL1 = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/"
    let spoonacularURL2 = "/information?includeNutrition=false"
    
    var instructionSearchService: InstructionSearchService?
    var passedRecipe: ComplexRecipeSearchService.ComplexRecipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let session = URLSession(configuration: .default)
        
        let recipePicURL = URL(string: (self.passedRecipe?.image)!)!
        
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
        

        // Do any additional setup after loading the view.
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
