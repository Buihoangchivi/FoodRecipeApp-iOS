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

//Bien quan ly upload anh
var uploadTask: StorageUploadTask?

let CategoryList = [
    NSLocalizedString("Heo", comment: "Thịt heo"),
    NSLocalizedString("Bo", comment: "Thịt bò"),
    NSLocalizedString("Ga", comment: "Thịt gà"),
    NSLocalizedString("Vit", comment: "Thịt vịt"),
    NSLocalizedString("Hai san", comment: "Hải sản"),
    NSLocalizedString("Ca", comment: "Cá"),
    NSLocalizedString("Banh", comment: "Bánh"),
    NSLocalizedString("Trai cay", comment: "Trái cây"),
    NSLocalizedString("An chay", comment: "Ăn chay"),
    NSLocalizedString("Giam can", comment: "Giảm cân"),
    NSLocalizedString("Chien xao", comment: "Chiên xào"),
    NSLocalizedString("Mon canh", comment: "Món canh"),
    NSLocalizedString("Mon nuong", comment: "Món nướng"),
    NSLocalizedString("Mon kho", comment: "Món kho"),
    NSLocalizedString("Mon nhau", comment: "Món nhậu"),
    NSLocalizedString("Tiet kiem", comment: "Tiết kiệm"),
    NSLocalizedString("Le", comment: "Ngày lễ, tết"),
    NSLocalizedString("Khac", comment: "Khác")
]
let MealList = [
    NSLocalizedString("Sang", comment: "Bữa sáng"),
    NSLocalizedString("Trua", comment: "Bữa trưa"),
    NSLocalizedString("Toi", comment: "Bữa tối"),
    NSLocalizedString("Phu", comment: "Bữa phụ"),
    NSLocalizedString("Khac", comment: "Khác")
]

let MenuList = [
    NSLocalizedString("Favorite", comment: "Món ăn yêu thích"),
    NSLocalizedString("UserFood", comment: "Công thức nhà mình"),
    NSLocalizedString("Tip", comment: "Mẹo hay"),
    NSLocalizedString("Le", comment: "Món ăn ngày lễ"),
    NSLocalizedString("An chay", comment: "Món ăn chay"),
    NSLocalizedString("Giam can", comment: "Món ăn giảm cân"),
    NSLocalizedString("Banh", comment: "Món bánh ngon"),
    NSLocalizedString("Mon nhau", comment: "Món nhậu cơ bản"),
    NSLocalizedString("Contact", comment: "Liên hệ"),
    NSLocalizedString("Setting", comment: "Cài đặt"),
    NSLocalizedString("Logout", comment: "Đăng xuất")
]

var CurrentUsername = ""
var isUserMode = false
var ColorScheme = UIColor.systemGreen
var ColorList = [String]()

var LoginMethod:Int?
