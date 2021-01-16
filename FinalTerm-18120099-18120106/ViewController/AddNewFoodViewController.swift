//
//  AddNewFoodViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/30/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase

class AddNewFoodViewController: UIViewController {

    @IBOutlet weak var FoodImageView: UIImageView!
    
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var MealCollectionView: UICollectionView!
    
    @IBOutlet weak var FoodNameTextField: UITextField!
    
    @IBOutlet weak var AddImageButton: UIButton!
    @IBOutlet weak var AddIngredientButton: UIButton!
    @IBOutlet weak var AddStepButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    var SelectedCategory = [Bool]()
    var SelectedMeal = [Bool]()
    var SelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var TempSelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var SelectedDirection = [String]()
    var imagePicker = UIImagePickerController()
    var delegate: AddNewFoodDelegate?
    var uploadTask: StorageUploadTask?
    var isAddFoodImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Bo tron goc cho cac nut them anh, them nguyen lieu, them buoc
        AddImageButton.layer.cornerRadius = 17.5
        AddIngredientButton.layer.cornerRadius = 17.5
        AddStepButton.layer.cornerRadius = 17.5
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderColor = UIColor.systemGreen.cgColor
        CancelButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 22
        
        //Bo tron goc cho anh mon an
        //FoodImageView.layer.cornerRadius = 100
        
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
    
    @IBAction func act_ShowHomeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.DismissWithCondition(0)
    }
    
    @IBAction func act_ShowShoppingListScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.DismissWithCondition(2)
    }
    
    @IBAction func act_AddFoodImage(_ sender: Any) {
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
    
    @IBAction func act_SaveNewFood(_ sender: Any) {
        var count = 0
        var path = ""
        var imagePath = ""
        //Che do User
        if (isUserMode == true) {
            
            path = "UserList/\(CurrentUsername)/FoodList"
            imagePath = "/UserImages//\(CurrentUsername)"
            
        }
        else { //Che do Admin
            
            path = "FoodList"
            imagePath = "/FoodImages"
            
        }
        FirebaseRef.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            //Xac dinh ID cho mon an moi
            for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let id = Int(temp.key) {
                    if id != count {
                        break
                    }
                    else {
                        count += 1
                    }
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
            
            //Upload anh mon an va ten anh len Firebase
            if (self.isAddFoodImage == true) {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                self.uploadTask = imageRef.child("\(imagePath)/\(count).jpg").putData((self.FoodImageView.image?.sd_imageData(as: .JPEG, compressionQuality: 1.0, firstFrameOnly: true))!, metadata: metadata) { (metadata, error) in
                    }
                // Create a task listener handle
                self.uploadTask!.observe(.progress) { snapshot in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    self.DisplayValueInProgressBar(PercentCompleted: percentComplete)
                }
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
            
            //Day tat ca thong tin cua mon an len Firebase
            FirebaseRef.child("\(path)/\(count)").setValue(["Category": tempCategoryArr, "Direction": self.SelectedDirection, "Favorite": 0, "Image": "\(count).jpg","Ingredient": tempIngredientArr, "Meal": tempMealArr, "Name": self.FoodNameTextField.text!]) { (err, ref) in
                self.delegate?.UpdateUI()
                self.act_ShowHomeScreen(sender)
            }
        })
    }

    func DisplayValueInProgressBar(PercentCompleted value: Double) {
        print(value)
        if (value == 100.0) {
            print("Done!")
            uploadTask!.removeAllObservers()
        }
    }
}

//Delegate cua nguyen lieu
extension AddNewFoodViewController : IngredientDelegate {
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
extension AddNewFoodViewController: DirectionDelegate {
    func SaveChange(List: [String]) {
        SelectedDirection = List
    }
}

//Delegate chon hinh anh tu thu vien
extension AddNewFoodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension AddNewFoodViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealForAddFoodCell", for: indexPath as IndexPath) as! MealForAddFoodCollectionViewCell
            
            cell.MealLabel.text = MealList[indexPath.row]
            cell.layer.cornerRadius = 20
            
            if (SelectedMeal[indexPath.row] == true) {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 20)
                cell.MealLabel.textColor = UIColor.black
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.systemGreen.cgColor
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
