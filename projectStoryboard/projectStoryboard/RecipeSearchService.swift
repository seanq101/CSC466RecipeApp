//
//  RecipeSearchService.swift
//  projectStoryboard
//
//  Copyright © 2019 Sean Quinn. All rights reserved.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import Foundation

/*** Response Body ***
 
[
    0:{10 items
    "id":48191
    "title":"Apple Crumble Recipe"
    "image":"https://spoonacular.com/recipeImages/48191-312x231.jpg"
    "imageType":"jpg"
    "usedIngredientCount":3
    "missedIngredientCount":4
    "missedIngredients":[4 items
        0:{
            "id":4073
            "amount":35
            "unit":"g"
            "unitLong":"grams"
            "unitShort":"g"
            "aisle":"Milk, Eggs, Other Dairy"
            "name":"margarine"
            "original":"35 g margarine or butter"
            "originalString":"35 g margarine or butter"
            "originalName":"margarine or butter"
            "metaInformation":[]0 items
            "image":"https://spoonacular.com/cdn/ingredients_100x100/butter-sliced.jpg"
        }
        1:{...}12 items
        2:{...}12 items
        3:{...}12 items
    ]
    "usedIngredients":[...]3 items
    "unusedIngredients":[...]1 item
    "likes":965
    }
    1:{
        "id":534573
        "title":"Brown Butter Apple Crumble"
        "image":"https://spoonacular.com/recipeImages/534573-312x231.jpg"
        "imageType":"jpg"
        "usedIngredientCount":3
        "missedIngredientCount":5
        "missedIngredients":[...]5 items
        "usedIngredients":[...]3 items
        "unusedIngredients":[]0 items
        "likes":7
    }
*/

struct RecipeSearchService : Codable {
    let id : Int
    let title : String
    let likes : Int
    let image : String
    let imageType : String
    let usedIngredientCount : Int
    let missedIngredientCount : Int
    let missedIngredients : [Ingredient]
    let usedIngredients : [Ingredient]
    let unusedIngredients : [Ingredient]

    // Make this more in depth by adding another struct
    struct Ingredient : Codable {
        let id : Int
        let amount : Float
        let unitLong : String
        let originalName : String
        let image : String
    }
}

//"id":48191
//"title":"Apple Crumble Recipe"
//"image":"https://spoonacular.com/recipeImages/48191-312x231.jpg"
//"imageType":"jpg"
//"usedIngredientCount":3
//"missedIngredientCount":4

//"id":4073
//"amount":35
//"unit":"g"
//"unitLong":"grams"
//"unitShort":"g"
//"aisle":"Milk, Eggs, Other Dairy"
//"name":"margarine"
//"original":"35 g margarine or butter"
//"originalString":"35 g margarine or butter"
//"originalName":"margarine or butter"
//"metaInformation":[]0 items
//"image":"https://spoonacular.com/cdn/ingredients_100x100/butter-sliced.jpg"
