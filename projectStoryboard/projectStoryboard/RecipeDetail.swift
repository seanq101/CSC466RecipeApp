//
//  RecipeDetail.swift
//  projectStoryboard
//
//  Created by Sean Quinn on 5/27/19.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import UIKit

class RecipeDetail: UIViewController{
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lngredientsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var passedRecipe: RecipeSearchService?
    
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
