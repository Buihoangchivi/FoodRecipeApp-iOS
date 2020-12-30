//
//  ShoppingListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/8/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var NotificationLabel: UILabel!
    @IBOutlet weak var EstablishMenuButton: UIButton!
    @IBOutlet weak var ShoppingListTableView: UITableView!
    @IBOutlet weak var ShoppingListView: UIView!
    
    var dateData = Date()
    var ShoppingList = [(FoodName: String, IngredientName: String, Value: String, Check: Bool)]()
    var IngredientList = [(Name: String, Unit: String)]()
    var delegate: AddNewFoodDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //An dau ngan cach giua cac TableViewCell
        ShoppingListTableView.separatorStyle = .none
        //Khong cho chon cell
        ShoppingListTableView.allowsSelection = false
        
        //Lay danh sach thong tin tat ca cac nguyen lieu
        FirebaseRef.child("IngredientList").observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let arr = temp.value as? NSArray {
                    self.IngredientList += [(Name: arr[0] as! String, Unit: arr[1] as! String)]
                    }
                }
        })
        
        //Bo tron goc cho nut Len thuc don
        EstablishMenuButton.layer.cornerRadius = 22
        
        //Doc du lieu tren Firebase va hien len man hinh
        LoadDataFromFirebase(dateData)
    }
    
    @IBAction func act_ShowHomeScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.DismissWithCondition(0)
    }
    
    @IBAction func act_ShowAddNewFoodScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.DismissWithCondition(1)
    }
    
    func LoadDataFromFirebase(_ date: Date) {
        //Khoi tao danh sach cac mon an trong menu
        ShoppingList = [(FoodName: String, IngredientName: String, Value: String, Check: Bool)]()
        let path = DateToString(date, "yyyy/MM/dd")
        FirebaseRef.child("ShoppingList/\(path)").observeSingleEvent(of: .value) { (snapshot) in
            //Kiem tra co ton tai menu trong ngay duoc chon hay khong
            if (snapshot.exists() == false) {
                //An View chua TableView
                self.ShoppingListView.isHidden = true
                //Hien thi thong bao khong co menu
                self.EstablishMenuButton.isHidden = false
                self.EstablishMenuButton.isEnabled = true
                self.NotificationLabel.isHidden = false
                if (self.DateLabel.text == "Hôm nay") {
                    self.NotificationLabel.text = "Bạn chưa chọn món cho thực đơn hôm nay!"
                }
                else if (self.DateLabel.text == "Hôm qua") {
                    self.NotificationLabel.text = "Bạn chưa chọn món cho thực đơn hôm qua!"
                }
                else if (self.DateLabel.text == "Ngày mai") {
                    self.NotificationLabel.text = "Bạn chưa chọn món cho thực đơn ngày mai!"
                }
                else {
                    self.NotificationLabel.text = "Bạn chưa chọn món cho thực đơn ngày \(self.DateLabel.text!)!"
                }
            }
            else {
                for snapshotChild in snapshot.children {
                    let child = snapshotChild as! DataSnapshot
                    var temp = (FoodName: "", IngredientName: "", Value: "", Check: false)
                    //Them khoang cach giua cac mon an
                    if (self.ShoppingList.count > 0) {
                        self.ShoppingList += [temp]
                    }
                    if let menu = child.value as? [String:AnyObject] {
                        foodInfoRef.child("\(menu["FoodID"] as! Int)").observeSingleEvent(of: .value) { (snapshot) in
                            if let food = snapshot.value as? [String:Any] {
                                //Lay danh sach nguyen lieu cua mon an ung voi ID
                                if let arr = food["Ingredient"] as? NSArray {
                                    for i in 0..<arr.count {
                                        if let info = arr[i] as? NSArray {
                                            //Lay ten mon an ung voi ID
                                            if (i == 0) {
                                                temp = (FoodName: food["Name"] as! String, IngredientName: "", Value: "", Check: false)
                                                self.ShoppingList += [temp]
                                            }
                                            
                                            //Kiem tra xe nguyen lieu dang xet co duoc danh dau hay chua
                                            var check = false
                                            if let checkArr = menu["CheckList"] as? NSArray {
                                                for element in checkArr {
                                                    if (i == element as! Int) {
                                                        check = true
                                                        break
                                                    }
                                                }
                                            }
                                            
                                            //Them nguyen lieu vao danh sach
                                            temp = (FoodName: "", IngredientName: self.IngredientList[info[0] as! Int].Name, Value: "\(info[1]) \(self.IngredientList[info[0] as! Int].Unit)", Check: check)
                                            self.ShoppingList += [temp]
                                            
                                            //Them khoang cach giua cac mon an
                                            if (i == arr.count - 1) {
                                                temp = (FoodName: "", IngredientName: "", Value: "", Check: false)
                                                self.ShoppingList += [temp]
                                            }
                                        }
                                    }
                                }
                            }
                            self.ShoppingListTableView.reloadData()
                            //Hien View chua TableView di
                            self.ShoppingListView.isHidden = false
                            //An thong bao khong co menu
                            self.EstablishMenuButton.isEnabled = false
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func act_ShowDatePicker(_ sender: Any) {
        let myPopUp = self.storyboard?.instantiateViewController(identifier: "DatePickerPopUpViewController") as! DatePickerPopUpViewController
        myPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myPopUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        myPopUp.delegate = self
        myPopUp.DefaultDate = dateData
        self.present(myPopUp, animated: true, completion: nil)
    }
    
    @IBAction func ChangeCheckState(_ sender: Any) {
        let button = sender as! UIButton
        //Mang luu trang thai cua cac nguyen lieu
        var stateArr = [Int]()
        //Vi tri bat dau va ket thuc cua mang chua cac nguyen lieu cua mon an dang xet
        let start = GetLeadingIndex(button.tag)
        let end = GetTrailingIndex(button.tag)
        
        if (button.tintColor == UIColor.systemGreen) {
            ShoppingList[button.tag].Check = false
        }
        else {
            ShoppingList[button.tag].Check = true
        }
        
        for i in start...end {
            if (ShoppingList[i].Check == true) {
                stateArr += [i - start]
            }
        }
        
        //Xac dinh chi so cua mon an luu trong mang
        var index = 0
        for i in 0..<start - 1 {
            if (ShoppingList[i].FoodName != "") {
                index += 1
            }
        }
        
        //Cap nhat lai du lieu tren Firebase
        let path = DateToString(dateData, "yyyy/MM/dd")
        FirebaseRef.child("ShoppingList/\(path)/\(index)/CheckList").setValue(stateArr)
        
        //Cap nhat lai giao dien
        ShoppingListTableView.reloadData()
    }
    
    @IBAction func DeleteFoodInMenu(_ sender: Any) {
        let button = sender as! UIButton
        
        //Xac dinh chi so cua mon an luu trong mang
        var index = 0
        for i in 0..<button.tag {
            if (ShoppingList[i].FoodName != "") {
                index += 1
            }
        }
        
        //Lay duong dan ngay thang nam den menu chua mon an can xoa
        let path = DateToString(dateData, "yyyy/MM/dd")
        
        //Xoa du lieu mon an trong mang
        FirebaseRef.child("ShoppingList/\(path)").observeSingleEvent(of: .value) { (snapshot) in
        if (snapshot.exists() == true) {
            var menuArr = [[String:AnyObject]]()
            for snapshotChild in snapshot.children {
                let child = snapshotChild as! DataSnapshot
                if let menu = child.value as? [String:AnyObject] {
                    menuArr += [menu]
                }
            }
            //Xoa danh sach nguyen lieu cua mon an co chi so 'index' trong thuc don
            menuArr.remove(at: index)
            
            //Cap nhat lai du lieu tren Firebase
            FirebaseRef.child("ShoppingList/\(path)").setValue(menuArr)
            }
        }
        
        let end = GetTrailingIndex(button.tag + 1)
        for _ in button.tag...end + 1 {
            ShoppingList.remove(at: button.tag)
        }
        //Neu khong con mon an nao trong menu thi hien thi thong bao khong co mon an trong thuc don
        if (ShoppingList.count == 0) {
            //An View chua TableView
            ShoppingListView.isHidden = true
            //Hien thi thong bao khong co menu
            EstablishMenuButton.isHidden = false
            EstablishMenuButton.isEnabled = true
            NotificationLabel.isHidden = false
            if (DateLabel.text == "Hôm nay") {
                NotificationLabel.text = "Bạn chưa chọn món cho thực đơn hôm nay!"
            }
            else if (DateLabel.text == "Hôm qua") {
                NotificationLabel.text = "Bạn chưa chọn món cho thực đơn hôm qua!"
            }
            else if (DateLabel.text == "Ngày mai") {
                NotificationLabel.text = "Bạn chưa chọn món cho thực đơn ngày mai!"
            }
            else {
                NotificationLabel.text = "Bạn chưa chọn món cho thực đơn ngày \(DateLabel.text!)!"
            }
        }
        else { //Cap nhat lai giao dien
            LoadDataFromFirebase(dateData)
        }
        
    }
    
    func GetLeadingIndex(_ currentIndex: Int) -> Int {
        var index = currentIndex
        while (true) {
            if (ShoppingList[index].FoodName != "") {
                break
            }
            index -= 1
        }
        return index + 1
    }
    
    func GetTrailingIndex(_ currentIndex: Int) -> Int {
        var index = currentIndex
        while (true) {
            if (ShoppingList[index].IngredientName == "") {
                break
            }
            index += 1
        }
        return index - 1
    }
}

extension ShoppingListViewController: DatePickerDalegate {
    func TransmitDate(Date date: Date) {
        let calendar = Calendar.current
        dateData = date
        if (calendar.isDateInToday(date) == true) {
            DateLabel.text = "Hôm nay"
        }
        else if (calendar.isDateInYesterday(date) == true) {
            DateLabel.text = "Hôm qua"
        }
        else if (calendar.isDateInTomorrow(date) == true) {
            DateLabel.text = "Ngày mai"
        }
        else {
            DateLabel.text = DateToString(date, "dd/MM/yyyy")
        }
        //Doc du lieu tren Firebase va hien len man hinh
        LoadDataFromFirebase(dateData)
    }
}

extension ShoppingListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListTableViewCell
        cell.FoodNameLabel.text = ShoppingList[indexPath.row].FoodName
        cell.IngredientNameLabel.text = ShoppingList[indexPath.row].IngredientName
        cell.ValueAndUnitLabel.text = ShoppingList[indexPath.row].Value
        //Cell khong chua ten mon an
        if (ShoppingList[indexPath.row].FoodName == "") {
            //An nut xoa
            cell.DeleteButton.isHidden = true
            cell.DeleteButton.isEnabled = false
            //An dau cham dau ten mon an
            cell.CircleImageView.isHidden = true
        }
        else { //Cell chua ten mon an
            //Gan su kien cho nut xoa
            cell.DeleteButton.tag = indexPath.row
            cell.DeleteButton.addTarget(self, action: #selector(DeleteFoodInMenu(_:)), for: .touchUpInside)
            //Hien thi nut xoa
            cell.DeleteButton.isHidden = false
            cell.DeleteButton.isEnabled = true
            //Hien thi dau cham dau ten
            cell.CircleImageView.isHidden = false
        }
        //Cell chua thong tin nguyen lieu
        if (ShoppingList[indexPath.row].IngredientName != "") {
            if (ShoppingList[indexPath.row].Check == true) {
                //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
                cell.CheckButton.tag = indexPath.row
                cell.CheckButton.addTarget(self, action: #selector(ChangeCheckState(_:)), for: .touchUpInside)
                
                cell.CheckButton.isHidden = false
                cell.CheckButton.isEnabled = true
                cell.UncheckButton.isHidden = true
                cell.UncheckButton.isEnabled = false
            }
            else {
                //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
                cell.UncheckButton.tag = indexPath.row
                cell.UncheckButton.addTarget(self, action: #selector(ChangeCheckState(_:)), for: .touchUpInside)
                
                cell.CheckButton.isHidden = true
                cell.CheckButton.isEnabled = false
                cell.UncheckButton.isHidden = false
                cell.UncheckButton.isEnabled = true
            }
        }
        else {
            cell.CheckButton.isHidden = true
            cell.CheckButton.isEnabled = false
            cell.UncheckButton.isHidden = true
            cell.UncheckButton.isEnabled = false

        }
        return cell
    }
}
