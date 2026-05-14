//
//  FoodModel.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 27/04/26.
//

import Foundation

struct FoodModel: Codable {
    let foodDetails: [FoodDetails]?
    
    enum CodingKeys: String, CodingKey {
        case foodDetails = "categories"
    }
    
    init(foodDetails: [FoodDetails]) {
        self.foodDetails = foodDetails
    }
}

struct FoodDetails: Codable, Identifiable {
    let idCategory : String?
    let strCategory : String?
    let strCategoryThumb : String?
    let strCategoryDescription : String?
    
    var id: String { idCategory ?? UUID().uuidString }
    
    enum CodingKeys: String, CodingKey {

        case idCategory = "idCategory"
        case strCategory = "strCategory"
        case strCategoryThumb = "strCategoryThumb"
        case strCategoryDescription = "strCategoryDescription"
    }
    
    init(idCategory: String, strCategory: String, strCategoryThumb: String, strCategoryDescription: String) {
        self.idCategory = idCategory
        self.strCategory = strCategory
        self.strCategoryThumb = strCategoryThumb
        self.strCategoryDescription = strCategoryDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idCategory = try values.decodeIfPresent(String.self, forKey: .idCategory)
        strCategory = try values.decodeIfPresent(String.self, forKey: .strCategory)
        strCategoryThumb = try values.decodeIfPresent(String.self, forKey: .strCategoryThumb)
        strCategoryDescription = try values.decodeIfPresent(String.self, forKey: .strCategoryDescription)
    }
}
