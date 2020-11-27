//
//  ViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/26/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ShoppingButton: UIButton!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var MealCollectionView: UICollectionView!
    
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var FoodView: UIView!
    
    @IBOutlet weak var FoodButton0: UIButton!
    @IBOutlet weak var FoodButton1: UIButton!
    @IBOutlet weak var FoodButton2: UIButton!
    @IBOutlet weak var FoodButton3: UIButton!
    @IBOutlet weak var FoodButton4: UIButton!
    @IBOutlet weak var FoodButton5: UIButton!
    
    @IBOutlet weak var FoodImage0: UIImageView!
    @IBOutlet weak var FoodImage1: UIImageView!
    @IBOutlet weak var FoodImage2: UIImageView!
    @IBOutlet weak var FoodImage3: UIImageView!
    @IBOutlet weak var FoodImage4: UIImageView!
    @IBOutlet weak var FoodImage5: UIImageView!
    
    @IBOutlet weak var FoodName0: UILabel!
    @IBOutlet weak var FoodName1: UILabel!
    @IBOutlet weak var FoodName2: UILabel!
    @IBOutlet weak var FoodName3: UILabel!
    @IBOutlet weak var FoodName4: UILabel!
    @IBOutlet weak var FoodName5: UILabel!
    
    
    var SelectedCategory = Array(repeating: false, count: 16)
    var SelectedMeal = Array(repeating: false, count: 4)
    
    let CategoryList = ["Thịt heo", "Thịt bò", "Thịt gà", "Hải sản", "Cá", "Bánh", "Trái cây", "Ăn chay", "Giảm cân", "Chiên xào", "Món canh", "Món nướng", "Món kho", "Món nhậu", "Tiết kiệm", "Ngày lễ, tết"]
    let MealList = ["Bữa sáng", "Bữa trưa", "Bữa tối", "Bữa phụ"]
    var FoodImageOutletList = [UIImageView]()
    var FoodNameOutletList = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Init()
        // Do any additional setup after loading the view.
    }

    func Init() {
        //Layout thanh loai thuc an
        var layout = CategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5,left: 5,bottom: 0,right: 15)
        
        //Layout thanh loai bua an
        layout = MealCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        
        //Layout bo goc va do bong cho nen 6 mon an
        FoodView.layer.cornerRadius = 10
        FoodView.layer.borderWidth = 0.1
        FoodView.layer.masksToBounds = true
        
        ShadowView.layer.shadowColor = UIColor.black.cgColor
        ShadowView.layer.shadowRadius = 7
        ShadowView.layer.shadowOpacity = 0.5
        ShadowView.layer.shadowOffset = CGSize(width: -2, height: 5)
        
        //Luu danh sach Outlet vao List
        FoodImageOutletList = [FoodImage0, FoodImage1, FoodImage2, FoodImage3, FoodImage4, FoodImage5]
        FoodNameOutletList = [FoodName0, FoodName1, FoodName2, FoodName3, FoodName4, FoodName5]
    }
    
    @IBAction func act_ClickFoodButton(_ sender: Any) {
        let button = sender as! UIButton
        print(String(describing: button.restorationIdentifier))
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == CategoryCollectionView) {
            return CategoryList.count
        }
        else {
            return MealList.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Xu ly loai do an
        if (collectionView == CategoryCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            cell.CategoryLabel.text = CategoryList[indexPath.row]
            cell.layer.cornerRadius = 20
            
            if (SelectedCategory[indexPath.row] == true) {
                cell.CategoryLabel.font = UIFont(name: cell.CategoryLabel.font.familyName, size: 20)
                cell.CategoryLabel.backgroundColor = UIColor.systemGreen
                cell.CategoryLabel.textColor = UIColor.white
                cell.layer.borderWidth = 0
            }
            else {
                cell.CategoryLabel.font = UIFont(name: cell.CategoryLabel.font.familyName, size: 17)
                cell.CategoryLabel.backgroundColor = UIColor.white
                cell.CategoryLabel.textColor = UIColor.black
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.gray.cgColor
            }
            
            return cell
        }
        else { //Xu ly bua an
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath as IndexPath) as! MealCollectionViewCell
            
            cell.MealLabel.text = MealList[indexPath.row]
            
            if (SelectedMeal[indexPath.row] == true) {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 20)
                cell.MealLabel.textColor = UIColor.black
                cell.DashLabel.isHidden = false
            }
            else {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 17)
                cell.MealLabel.textColor = UIColor.gray
                cell.DashLabel.isHidden = true
            }
            
            return cell
        }
}
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == CategoryCollectionView) {
            //Neu dang duoc chon thi loai bo va nguoc lai
            if (SelectedCategory[indexPath.row] == true) {
                SelectedCategory[indexPath.row] = false
            }
            else {
                SelectedCategory[indexPath.row] = true
            }
            CategoryCollectionView.reloadData()
        }
        else {
            //Neu dang duoc chon thi loai bo va nguoc lai
            if (SelectedMeal[indexPath.row] == true) {
                SelectedMeal[indexPath.row] = false
            }
            else {
                SelectedMeal[indexPath.row] = true
            }
            MealCollectionView.reloadData()
        }
    }
}
