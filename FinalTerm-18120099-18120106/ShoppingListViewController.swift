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
    
    var dateData = Date()
    var ShoppingList = [(FoodName: String, IngredientName: String, Value: String, Check: Bool)]()
    var IngredientList = [(Name: String, Unit: String)]()
    
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
        foodInfoRef.child("IngredientList").observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let arr = temp.value as? NSArray {
                    self.IngredientList += [(Name: arr[0] as! String, Unit: arr[1] as! String)]
                    }
                }
        })
        var tempOrderArr = [(x: Int, y: Int)]()
        var count = 0, index = 0
        let path = DateToString(dateData, "yyyy/MM/dd")
        foodInfoRef.child("ShoppingList/\(path)").observeSingleEvent(of: .value) { (snapshot) in
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
                                count += arr.count + 2
                                for i in 0..<arr.count {
                                    if let info = arr[i] as? NSArray {
                                        var infoArr = [String]()
                                        foodInfoRef.child("IngredientList/\(info[0])").observeSingleEvent(of: .value, with: { (snapshot) in
                                            if (i == 0) {
                                                //Lay ten mon an ung voi ID
                                                temp = (FoodName: food["Name"] as! String, IngredientName: "", Value: "", Check: false)
                                                self.ShoppingList += [temp]
                                                tempOrderArr += [(x: Int(child.key)!, y: 0)]
                                                index += 1
                                            }
                                            //Lay thong tin nguyen lieu
                                            for snapshotChild in snapshot.children {
                                                let temp = snapshotChild as! DataSnapshot
                                                infoArr += [temp.value as! String]
                                            }
                                            var check = false
                                            if let checkArr = menu["CheckList"] as? NSArray {
                                                for element in checkArr {
                                                    if (i == element as! Int) {
                                                        check = true
                                                        break
                                                    }
                                                }
                                            }
                                            temp = (FoodName: "", IngredientName: infoArr[0], Value: "\(info[1]) \(infoArr[1])", Check: check)
                                            self.ShoppingList += [temp]
                                            tempOrderArr += [(x: Int(child.key)!, y: i + 1)]
                                            index += 1
                                            //Them khoang cach giua cac mon an
                                            if (i == arr.count - 1) {
                                                temp = (FoodName: "", IngredientName: "", Value: "", Check: false)
                                                self.ShoppingList += [temp]
                                                tempOrderArr += [(x: Int(child.key)!, y: i + 2)]
                                                index += 1
                                            }
                                            if (index == count) {
                                                //Sap xep danh sach nguyen lieu theo dung thu tu
                                                for i in 0..<self.ShoppingList.count - 1 {
                                                    for j in i + 1..<self.ShoppingList.count {
                                                        if (tempOrderArr[i].x > tempOrderArr[j].x ||
                                                            (tempOrderArr[i].x == tempOrderArr[j].x && tempOrderArr[i].y > tempOrderArr[j].y)) {
                                                            tempOrderArr.swapAt(i, j)
                                                            self.ShoppingList.swapAt(i, j)
                                                        }
                                                    }
                                                }
                                                self.ShoppingListTableView.reloadData()
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func DateToString(_ date: Date, _ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
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
        if (button.tintColor == UIColor.systemGreen) {
            ShoppingList[button.tag].Check = false
        }
        else {
            ShoppingList[button.tag].Check = true
        }
        ShoppingListTableView.reloadData()
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
    }
}

extension ShoppingListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingList.count
    }
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        return footerView
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell") as! ShoppingListTableViewCell
        cell.FoodNameLabel.text = ShoppingList[indexPath.row].FoodName
        cell.IngredientNameLabel.text = ShoppingList[indexPath.row].IngredientName
        cell.ValueAndUnitLabel.text = ShoppingList[indexPath.row].Value
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
