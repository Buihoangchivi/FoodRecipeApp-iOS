//
//  EditFoodViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/16/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class EditFoodViewController: UIViewController {
    
    @IBOutlet weak var FoodImageView: UIImageView!
    
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var MealCollectionView: UICollectionView!
    
    @IBOutlet weak var FoodNameTextField: UITextField!
    
    @IBOutlet weak var AddImageButton: UIButton!
    @IBOutlet weak var AddIngredientButton: UIButton!
    @IBOutlet weak var AddStepButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var EditLabel: UILabel!
    
    //Duong dan luu thong tin va hinh anh mon an tren Firebase
    var editFoodRef = DatabaseReference()
    var editImageRef = StorageReference()
    
    var SelectedCategory = [Bool]()
    var SelectedMeal = [Bool]()
    var SelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var TempSelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var SelectedDirection = [String]()
    var imagePicker = UIImagePickerController()
    var delegate: EditFoodDelegate?
    var isAddFoodImage = false
    var fav = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        UIInit()
        FoodInfoInit()
    }
    
    //Khoi tao giao dien man hinh chinh sua
    func UIInit() {
        
        //Chinh mau cho man hinh
        EditLabel.backgroundColor = ColorScheme
        AddImageButton.backgroundColor = ColorScheme
        AddIngredientButton.backgroundColor = ColorScheme
        AddStepButton.backgroundColor = ColorScheme
        SaveButton.backgroundColor = ColorScheme
        CancelButton.setTitleColor(ColorScheme, for: .normal)
        CancelButton.layer.borderColor = ColorScheme.cgColor
        
        //Bo tron goc cho cac nut them anh, them nguyen lieu, them buoc
        AddImageButton.layer.cornerRadius = 17.5
        AddIngredientButton.layer.cornerRadius = 17.5
        AddStepButton.layer.cornerRadius = 17.5
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 22
        
        //Khoi tao cho cac List
        SelectedCategory = Array(repeating: false, count: CategoryList.count)
        SelectedMeal = Array(repeating: false, count: MealList.count)
        
        //Layout thanh loai thuc an
        var layout = CategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5,left: 10,bottom: 0,right: 15)
        
        //Layout thanh loai bua an
        layout = MealCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5,left: 10,bottom: 0,right: 15)
    }
    
    //Khoi tao du lieu mon an can chinh sua len man hinh
    func FoodInfoInit() {
        
        //Hien thi thong tin mon an
        editFoodRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let food = snapshot.value as? [String:Any] {
                
                //Hien thi ten mon an
                self.FoodNameTextField.text = food["Name"] as? String
                
                //
                self.fav = food["Favorite"] as! Int
                
                //Cap nhat danh sach loai mon an
                if let arr = food["Category"] as? NSArray {
                    
                    for category in arr {
                        
                        if let index = category as? Int {
                            
                            self.SelectedCategory[index] = true
                            
                        }
                        
                    }
                    
                }
                
                //Cap nhat danh sach loai bua an
                if let arr = food["Meal"] as? NSArray {
                    
                    for meal in arr {
                        
                        if let index = meal as? Int {
                            
                            self.SelectedMeal[index] = true
                            
                        }
                        
                    }
                    
                }
                
                //Cap nhat danh sach nguyen lieu
                if let arr = food["Ingredient"] as? NSArray {
                    
                    for pair in arr {
                        
                        if let pairArr = pair as? NSArray {
                            
                            var infoArr = [String]()
                            FirebaseRef.child("IngredientList/\(pairArr[0])").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                for snapshotChild in snapshot.children {
                                    let temp = snapshotChild as! DataSnapshot
                                    infoArr += [temp.value as! String]
                                }
                                
                                self.SelectedIngredient += [(ID: pairArr[0] as! Int, Name: infoArr[0], Value: pairArr[1] as! Double, Unit: infoArr[1])]
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                //Cap nhat danh sach cac buoc che ben mon an
                if let arr = food["Direction"] as? NSArray {
                 
                    for step in arr {
                            
                        self.SelectedDirection += [step as! String]
                        
                    }
                    
                }
                
                //Cap nhat Collection View cho loai mon an va loai bua an
                self.CategoryCollectionView.reloadData()
                self.MealCollectionView.reloadData()
            }
        })
        
        //Hien thi hinh anh mon an
        FoodImageView.sd_setImage(with: editImageRef, maxImageSize: 1 << 30, placeholderImage: UIImage(named: "food-background"), options: .retryFailed, completion: nil)
        //
    }
    
    @IBAction func act_EditFoodImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
            imagePicker.delegate = self
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            isAddFoodImage = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Hien thi man hinh chua danh sach nguyen lieu
    @IBAction func act_ShowIngredientList(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "IngredientListViewController") as! IngredientListViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.SelectedIngredient = self.SelectedIngredient
        TempSelectedIngredient = SelectedIngredient
        self.present(dest, animated: true, completion: nil)
    }
    
    //Hien thi man hinh chua danh sach cac buoc
    @IBAction func act_ShowStepsList(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "DirectionListViewController") as! DirectionListViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.DirectionList = self.SelectedDirection
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_SaveChange(_ sender: Any) {
        
        var imageName = ""
        editFoodRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //Xac dinh ID cho mon an moi
            for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if temp.key == "Image" {
                    
                    imageName = temp.value as! String
                    
                }
            }
            
            //Ghi du lieu loai mon an len Firebase
            var tempCategoryArr = [Int]()
            for i in 0..<self.SelectedCategory.count {
                if (self.SelectedCategory[i] == true) {
                    tempCategoryArr += [i]
                }
            }
            if (tempCategoryArr.count == 0) {
                //Loai khac
                tempCategoryArr += [self.SelectedCategory.count - 1]
            }
            
            //Ghi du lieu danh sach nguyen lieu len Firebase
            var tempIngredientArr = [[Double]]()
            for i in 0..<self.SelectedIngredient.count {
                tempIngredientArr += [[Double(self.SelectedIngredient[i].ID), self.SelectedIngredient[i].Value]]
            }
            
            //Ghi du lieu loai bua an len Firebase
            var tempMealArr = [Int]()
            for i in 0..<self.SelectedMeal.count {
                if (self.SelectedMeal[i] == true) {
                    tempMealArr += [i]
                }
            }
            if (tempMealArr.count == 0) {
                //Loai khac
                tempMealArr += [self.SelectedMeal.count - 1]
            }
            
            //Cap nhat tat ca thong tin cua mon an len Firebase
            self.editFoodRef.setValue(["Category": tempCategoryArr, "Direction": self.SelectedDirection, "Favorite": self.fav, "Image": imageName, "Ingredient": tempIngredientArr, "Meal": tempMealArr, "Name": self.FoodNameTextField.text!])
            
            //Upload anh mon an va ten anh len Firebase
            if (self.isAddFoodImage == true) {
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                uploadTask = self.editImageRef.putData((self.FoodImageView.image?.sd_imageData(as: .JPEG, compressionQuality: 1.0, firstFrameOnly: true))!, metadata: metadata) { (metadata, error) in }
                
                // Create a task listener handle
                uploadTask!.observe(.progress) { snapshot in
                    
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    DisplayValueInProgressBar(PercentCompleted: percentComplete)
                    
                    //Hoan thanh upload anh len tren Firebase thi bat dau cap nhat du lieu mon an
                    if (percentComplete == 100.0) {
                        
                        //Cap nhat lai giao dien cua man hinh Chi tiet mon an
                        
                            self.delegate?.UpdateUI()
                            self.dismiss(animated: true, completion: nil)
                            
                    }
                }
            
            }
            else {
                
                //Cap nhat lai giao dien cua man hinh Chi tiet mon an
                    self.delegate?.UpdateUI()
                    self.dismiss(animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    @IBAction func act_ShowDetailScreen(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

//Delegate cua nguyen lieu
extension EditFoodViewController : IngredientDelegate {
    func UpdateIngredient(ingredient: (ID: Int, Name: String, Value: Double, Unit: String)) {
        var check = false
        for i in 0..<SelectedIngredient.count {
            if (SelectedIngredient[i].ID == ingredient.ID) {
                TempSelectedIngredient[i] = ingredient
                check = true
            }
        }
        if (check == false) {
            TempSelectedIngredient += [ingredient]
        }
    }
    
    func SaveChange() {
        var i = 0
        while i < TempSelectedIngredient.count {
            if (TempSelectedIngredient[i].Value == 0) {
                TempSelectedIngredient.remove(at: i)
                i -= 1
            }
            i += 1
        }
        SelectedIngredient = TempSelectedIngredient
    }
}

//Delegate cua cac buoc
extension EditFoodViewController: DirectionDelegate {
    func SaveChange(List: [String]) {
        SelectedDirection = List
    }
}

//Delegate chon hinh anh tu thu vien
extension EditFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] {
                self.FoodImageView.image = image as? UIImage
                self.isAddFoodImage = true
            }
        }
    }
}

extension EditFoodViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
                cell.CategoryLabel.backgroundColor = ColorScheme
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealForAddFoodCell", for: indexPath as IndexPath) as! MealForAddFoodCollectionViewCell
            
            cell.MealLabel.text = MealList[indexPath.row]
            cell.layer.cornerRadius = 20
            
            if (SelectedMeal[indexPath.row] == true) {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 20)
                cell.MealLabel.textColor = ColorScheme
                cell.layer.borderWidth = 1
                cell.layer.borderColor = ColorScheme.cgColor
            }
            else {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 17)
                cell.MealLabel.textColor = UIColor.gray
                cell.layer.borderWidth = 0
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
