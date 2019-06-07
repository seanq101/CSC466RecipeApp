//
//  FoodItem.swift
//  projectStoryboard
//
//  Copyright © 2019 Andrew Puleo. All rights reserved.
//  Copyright © 2019 Sean Quinn. All rights reserved.
//

import os.log
import Foundation

class FoodItem : NSObject, NSCoding {
    
    
    var properName: String
    var apiName: String
    var quantity: Int
    var unit: String
    var expiry: Date
    
    init(properName: String, apiName: String, quantity: Int, unit: String, expiry: Date) {
        self.properName = properName
        self.apiName = apiName
        self.quantity = quantity
        self.unit = unit
        self.expiry = expiry
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(properName, forKey: PropertyKey.Name)
        aCoder.encode(apiName, forKey: PropertyKey.name)
        aCoder.encode(quantity, forKey: PropertyKey.num)
        aCoder.encode(unit, forKey: PropertyKey.unit)
        aCoder.encode(expiry, forKey: PropertyKey.exp)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let properName = aDecoder.decodeObject(forKey: PropertyKey.Name) as? String else {
            os_log("Unable to decode the proper name for a foodItem object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let apiName = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the api name for a foodItem object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let quantity = aDecoder.decodeInteger(forKey: PropertyKey.num)
        
        guard let unit = aDecoder.decodeObject(forKey: PropertyKey.unit) as? String else {
            os_log("Unable to decode the name for a foodItem object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let expiry = aDecoder.decodeObject(forKey: PropertyKey.exp) as? Date else {
            os_log("Unable to decode the api name for a foodItem object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Must call designated initializer.
//        self.init(name: name, ingredientsMissing: ingredientsMissing, ingredientsUsed: ingredientsUsed, tips: tips as! String)
        self.init(properName: properName, apiName: apiName, quantity: quantity, unit: unit, expiry: expiry)
    }
    
    struct PropertyKey {
        static let Name = "properName"
        static let name = "apiName"
        static let num = "quantity"
        static let unit = "unit"
        static let exp = "expiry"
    }
//    enum UnitEnum {
//        case oz
//        case lb
//        case kg
//        case cup
//        case liter
//        case gallon
//        case tbsp
//        case tsp
//        case other
//    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("pantry")
    
}
