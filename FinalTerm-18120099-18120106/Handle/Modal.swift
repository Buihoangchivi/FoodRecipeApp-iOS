//
//  Modal.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/31/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import Foundation
import Firebase

class FoodInfomation {
    var Name = ""
    var Image = ""
}

var FoodList = [FoodInfomation]()
let imageRef = Storage.storage().reference()
let FirebaseRef = Database.database().reference()
let foodInfoRef = FirebaseRef.child("FoodList")

let CategoryList = ["Thịt heo", "Thịt bò", "Thịt gà", "Thịt vịt", "Hải sản", "Cá", "Bánh", "Trái cây", "Ăn chay", "Giảm cân", "Chiên xào", "Món canh", "Món nướng", "Món kho", "Món nhậu", "Tiết kiệm", "Ngày lễ, tết", "Khác"]
let MealList = ["Bữa sáng", "Bữa trưa", "Bữa tối", "Bữa phụ", "Khác"]
var CurrentUserID = ""
