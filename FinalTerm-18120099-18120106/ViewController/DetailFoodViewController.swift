//
//  DetailFoodViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class DetailFoodViewController: UIViewController{
    
    @IBOutlet weak var HeaderLb: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!

    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var NumberPersonLabel: UILabel!
    @IBOutlet weak var IngredientDash: UILabel!
    @IBOutlet weak var DirectionDash: UILabel!
    @IBOutlet weak var TextLabel: UILabel!
    
    @IBOutlet weak var ContentTableView: UITableView!
    
    @IBOutlet weak var btnAddtoMenu: UIButton!
    @IBOutlet weak var btnAddIngre: UIButton!
    @IBOutlet weak var IngredientButton: UIButton!
    @IBOutlet weak var DirectionButton: UIButton!
    @IBOutlet weak var DownNumberButton: UIButton!
    @IBOutlet weak var UpNumberButton: UIButton!
    @IBOutlet weak var FavoriteButton: UIButton!
    
    @IBOutlet weak var FavoriteButtonBackground: UIView!
    
    var SelectedIngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var DirectionList = [String]()
    var FoodID = 0
    var NumberOfPeople = 1
    var isIngredientView = true
    var delegate: DetailFoodDelegate?
    var Ref = foodInfoRef
    var folderName = "/FoodImages"
    var foodImageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        FoodInfoInit()
    }
    
    func UIInit() {
        //Khoi tao mau app
        HeaderLb.backgroundColor = ColorScheme
        IngredientButton.setTitleColor(ColorScheme, for: .normal)
        IngredientDash.backgroundColor = ColorScheme
        DirectionDash.backgroundColor = ColorScheme
        btnAddtoMenu.backgroundColor = ColorScheme
        btnAddIngre.setTitleColor(ColorScheme, for: .normal)
        btnAddIngre.layer.borderColor = ColorScheme.cgColor
        
        //Bo tron goc cho cac nut
        btnAddtoMenu.layer.cornerRadius = 22
        btnAddIngre.layer.cornerRadius = 22
        btnAddIngre.layer.borderWidth = 1
        IngredientButton.layer.cornerRadius = 10
        DirectionButton.layer.cornerRadius = 10
        
        //An dau ngan cach giua cac TableViewCell
        ContentTableView.separatorStyle = .none
        //Khong cho chon cell
        ContentTableView.allowsSelection = false
        
        //Bo tron nut yeu thich
        FavoriteButtonBackground.layer.cornerRadius = FavoriteButtonBackground.frame.height / 2
        
        //Xu ly 2 nut tang giam khau phan an
        if (NumberOfPeople == 1) {
            DownNumberButton.isEnabled = false
        }
        else if (NumberOfPeople == 10) {
            UpNumberButton.isEnabled = false
        }
        
    }
    
    func FoodInfoInit() {
      
      //Doc va hien thi thong tin cua mon an
      Ref.child("\(FoodID)").observeSingleEvent(of: .value, with: { (snapshot) in
          
          if let food = snapshot.value as? [String:Any] {
              
              //Hien thi hinh anh mon an
              self.FoodImageView.sd_setImage(with: imageRef.child("\(self.folderName)/\(food["Image"]!)"), maxImageSize: 1 << 30, placeholderImage: UIImage(named: "food-background"), options: .retryFailed, completion: nil)
              
              //Luu tru ten anh mon an
              self.foodImageName = food["Image"] as! String
              
              //Hien thi ten mon an
              self.FoodNameLabel.text = "\(food["Name"]!)"
              
              if (self.Ref.parent?.key == nil) { //Hiển thị trạng thái yêu thích trong chi tiết món ăn chung
                  
                  FirebaseRef.child("UserList/\(CurrentUsername)/Favorite/\(snapshot.key)").observeSingleEvent(of: .value) { (snapshot) in
                      
                      if (snapshot.exists() == true) { //Yeu thich
                          
                          self.FavoriteButton.tintColor = UIColor.red
                          self.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                          
                      }
                      else { //Khong yeu thich
                          
                          self.FavoriteButton.tintColor = UIColor.white
                          self.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                          
                      }
                      
                  }
                  
              }
              else { //Hiển thị trạng thái yêu thích trong chi tiết món ăn riêng của User
                  
                  if (food["Favorite"] as! Int == 1) { //Yeu thich
                      
                      self.FavoriteButton.tintColor = UIColor.red
                      self.FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                      
                  }
                  else { //Khong yeu thich
                      
                      self.FavoriteButton.tintColor = UIColor.white
                      self.FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                      
                  }
                  
            }
              
            //Hien thi nut "Xoa mon" va an nut yeu thich o che do Admin
            if (isUserMode == false) {
                
                self.btnAddtoMenu.setTitle("Xoá món", for: .normal)
                
                //An nut yeu thich
                self.FavoriteButton.isEnabled = false
                self.FavoriteButton.isHidden = true
                self.FavoriteButtonBackground.isHidden = true
                
            }
            else { //Hiển thị nút chọn món ở chế độ User
                
                self.btnAddtoMenu.setTitle("Chọn món", for: .normal)
                
            }
            
              //Xoa cache
              //SDImageCache.shared.clearMemory()
              //SDImageCache.shared.clearDisk()
              
          }
          
      })
      
      //Doc du lieu nguyen lieu mon an
      Ref.child("\(FoodID)/Ingredient").observeSingleEvent(of: .value, with: { (snapshot) in
              for snapshotChild in snapshot.children {
                  let temp = snapshotChild as! DataSnapshot
                      if let arr = temp.value as? NSArray {
                          var infoArr = [String]()
                          FirebaseRef.child("IngredientList/\(arr[0])").observeSingleEvent(of: .value, with: { (snapshot) in
                              for snapshotChild in snapshot.children {
                                  let temp = snapshotChild as! DataSnapshot
                                  infoArr += [temp.value as! String]
                              }
                          self.SelectedIngredientList += [(ID: arr[0] as! Int, Name: infoArr[0], Value: arr[1] as! Double, Unit: infoArr[1])]
                          DispatchQueue.main.async {
                              self.ContentTableView.reloadData()
                          }
                          })
                    }
              }
        })
      
      //Doc du lieu cac buoc thuc hien mon an
      Ref.child("\(FoodID)/Direction").observeSingleEvent(of: .value, with: { (snapshot) in
              for snapshotChild in snapshot.children {
                  let temp = snapshotChild as! DataSnapshot
                      self.DirectionList += [temp.value as! String]
                  }
              DispatchQueue.main.async {
                  self.ContentTableView.reloadData()
              }
      })
      
    }
    
    @IBAction func act_AddFoodToShoppingList(_ sender: Any) {
        
        //Nut Chon mon o che do User
        if (isUserMode == true) {
            
            let dest = self.storyboard?.instantiateViewController(identifier: "DatePickerPopUpViewController") as! DatePickerPopUpViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            self.present(dest, animated: true, completion: nil)
            
        }
        else { //Nut Xoa mon o che do Admin
            
            let dest = self.storyboard?.instantiateViewController(identifier: "DeleteFoodPopUpViewController") as! DeleteFoodPopUpViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            dest.FoodName = FoodNameLabel.text!
            dest.FoodID = FoodID
            self.present(dest, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func act_EditIngredient(_ sender: Any) {
        
        let dest = self.storyboard?.instantiateViewController(identifier: "EditFoodViewController") as! EditFoodViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.editFoodRef = Ref.child("\(FoodID)")
        dest.editImageRef = imageRef.child("\(self.folderName)/\(foodImageName)")
        self.present(dest, animated: true, completion: nil)
        
    }
        
    @IBAction func act_ShowDirection(_ sender: Any) {
        
        if (isIngredientView == true) {
            isIngredientView = false
            //Thay doi trang thai cua nut duoc chon
            IngredientButton.setTitleColor(UIColor.black, for: .normal)
            DirectionButton.setTitleColor(ColorScheme, for: .normal)
            
            //Thay doi dau gach
            IngredientDash.isHidden = true
            DirectionDash.isHidden = false
            //Thay doi thong tin khau phan an thanh thong tin tong so buoc
            TextLabel.text = "Tổng số bước:"
            NumberPersonLabel.text = "\(DirectionList.count)"
            //An 2 nut dieu chinh khau phan an
            DownNumberButton.isHidden = true
            DownNumberButton.isEnabled = false
            UpNumberButton.isHidden = true
            UpNumberButton.isEnabled = false
            //Hieu ung cuon len dau TableView
            if (SelectedIngredientList.count > 0 && DirectionList.count > 0) {
                ContentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            ContentTableView.reloadData()
        }
    }
    
    @IBAction func act_ShowIngredient(_ sender: Any) {
        if (isIngredientView == false) {
            isIngredientView = true
            //Thay doi trang thai cua nut duoc chon
            DirectionButton.setTitleColor(UIColor.black, for: .normal)
            IngredientButton.setTitleColor(ColorScheme, for: .normal)
            
            //Thay doi dau gach
            IngredientDash.isHidden = false
            DirectionDash.isHidden = true
            //Thay doi thong tin tong so buoc thanh thong tin khau phan an
            TextLabel.text = "Khẩu phần ăn:"
            NumberPersonLabel.text = "\(NumberOfPeople)"
            //An 2 nut dieu chinh khau phan an
            DownNumberButton.isHidden = false
            if (NumberOfPeople > 1) {
                DownNumberButton.isEnabled = true
            }
            UpNumberButton.isHidden = false
            if (NumberOfPeople < 10) {
                UpNumberButton.isEnabled = true
            }
            //Hieu ung cuon len dau TableView
            if (SelectedIngredientList.count > 0 && DirectionList.count > 0) {
                ContentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
            ContentTableView.reloadData()
        }
    }
    
    @IBAction func act_Back(_ sender: Any) {
        delegate?.Reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_DecreaseNumber(_ sender: Any) {
        NumberOfPeople -= 1
        if (NumberOfPeople == 1) {
            DownNumberButton.isEnabled = false
        }
        if (NumberOfPeople == 9) {
            UpNumberButton.isEnabled = true
        }
        NumberPersonLabel.text = String(NumberOfPeople)
        for i in 0..<SelectedIngredientList.count {
            SelectedIngredientList[i].Value *= Double(NumberOfPeople) / Double(NumberOfPeople + 1)
        }
        ContentTableView.reloadData()
    }
    
    @IBAction func act_IncreaseNumber(_ sender: Any) {
        NumberOfPeople += 1
        if (NumberOfPeople == 10) {
            UpNumberButton.isEnabled = false
        }
        if (NumberOfPeople == 2) {
            DownNumberButton.isEnabled = true
        }
        NumberPersonLabel.text = String(NumberOfPeople)
        for i in 0..<SelectedIngredientList.count {
            SelectedIngredientList[i].Value *= Double(NumberOfPeople) / Double(NumberOfPeople - 1)
        }
        ContentTableView.reloadData()
    }
    
    @IBAction func act_ChangeFavoriteStatus(_ sender: Any) {
        //Them vao danh sach yeu thich
        if (FavoriteButton.tintColor == UIColor.white) {
            
            FavoriteButton.tintColor = UIColor.red
            FavoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //Cap nhat data tren Firebase
            if (self.Ref.parent?.key == nil) { //Hiển thị trạng thái yêu thích trong chi tiết món ăn chung
                
                FirebaseRef.child("UserList/\(CurrentUsername)/Favorite/\(FoodID)").setValue("")
                
            }
            else { //Hiển thị trạng thái yêu thích trong chi tiết món ăn riêng của User
                
                Ref.child("\(FoodID)").updateChildValues(["Favorite": 1])
                
            }
            
        }
        else { //Xoa khoi danh sach yeu thich
            
            FavoriteButton.tintColor = UIColor.white
            FavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            //Cap nhat data tren Firebase
            if (self.Ref.parent?.key == nil) { //Hiển thị trạng thái yêu thích trong chi tiết món ăn chung
                
                FirebaseRef.child("UserList/\(CurrentUsername)/Favorite/\(FoodID)").removeValue()
                
            }
            else { //Hiển thị trạng thái yêu thích trong chi tiết món ăn riêng của User
                
                Ref.child("\(FoodID)").updateChildValues(["Favorite": 0])
                
            }
            
        }
    }
}

//Delegate cua cac buoc
extension DetailFoodViewController: DirectionDelegate {
    func SaveChange(List: [String]) {
        DirectionList = List
        NumberPersonLabel.text = "\(DirectionList.count)"
        ContentTableView.reloadData()
    }
}

//Delegate chon ngay cho thuc don
extension DetailFoodViewController: DatePickerDalegate{
    func TransmitDate(Date date: Date) {
        let path = DateToString(date, "yyyy/MM/dd")
        FirebaseRef.child("ShoppingList/\(path)").observeSingleEvent(of: .value) { (snapshot) in
            var index = 0
            var isExist = false
            if (snapshot.exists() == true) {
                for snapshotChild in snapshot.children {
                    let temp = snapshotChild as! DataSnapshot
                    if let info = temp.value as? [String:AnyObject] {
                        if self.FoodID == info["FoodID"] as! Int {
                            isExist = true
                            break
                        }
                    }
                }
                index = Int(snapshot.childrenCount)
            }
            
            if (isExist == false) {
            FirebaseRef.child("ShoppingList/\(path)/\(index)").setValue(["FoodID": self.FoodID])
            }
            }
    }
}

//Delegate cua nguyen lieu va cac buoc thuc hien
extension DetailFoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isIngredientView == true) {
            return SelectedIngredientList.count
        }
        else {
            return DirectionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (isIngredientView == true) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailIngredientCell") as! DetailIngredientFoodTableViewCell
            //Ten nguyen lieu
            cell.lbIngre.text = SelectedIngredientList[indexPath.row].Name
            //Gia tri nguyen lieu
            let temp = SelectedIngredientList[indexPath.row].Value
            if (Double(Int(temp)) != temp) {
                cell.lbNum.text = "\(Double(round(100 * temp) / 100))"
            }
            else {
                cell.lbNum.text = "\(Int(temp))"
            }
            //Don vi nguyen lieu
            cell.lbUnit.text = SelectedIngredientList[indexPath.row].Unit
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as! ProcessingTableViewCell
            cell.CircleImage.tintColor = ColorScheme
            cell.lbStep.text = "Bước \(indexPath.row + 1)"
            cell.lbDetail.text = "\(DirectionList[indexPath.row])"
            return cell
        }
    }
}

//Delegate cua chinh sua mon an
extension DetailFoodViewController: EditFoodDelegate {
    func UpdateUI() {
        
        //Reset lai danh sach nguyen lieu va buoc thuc hien mon an
        SelectedIngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
        DirectionList = [String]()
        
        //Cap nhat lai giao dien sau khi chinh sua
        FoodInfoInit()
        
    }
    
}

//Delegate cua xoa mon an
extension DetailFoodViewController: DeleteFoodDelegate {
    
    func ReloadAfterDeleteFood() {
        
        let dest = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
        
    }

}
