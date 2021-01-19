//
//  IngredientListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase

class IngredientListViewController: UIViewController {

    @IBOutlet weak var HeaderLb: UILabel!
    @IBOutlet weak var SearchIngredientLabel: UILabel!
    @IBOutlet weak var IngredientTableView: UITableView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var SearchTextField: UITextField!
    
    var IngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var IngredientIndexList = [Int]()
    var SelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    //0 la khong chinh sua nguyen lieu nao ca
    //1 la nhan nut chinh sua nguyen lieu
    //2 la nhan nut huy chinh sua
    //3 la nhan nut luu chinh sua
    var ButtonState = 0
    var CurrentEditRow = -1
    var checkClickSave = false
    weak var delegate : IngredientDelegate?
    var searchFoodName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Khoi tao mau app
        HeaderLb.backgroundColor = ColorScheme
        SaveButton.backgroundColor = ColorScheme
        CancelButton.setTitleColor(ColorScheme, for: .normal)
        CancelButton.layer.borderColor = ColorScheme.cgColor
        
        //Bo tron goc cho khung tim kiem
        SearchIngredientLabel.layer.cornerRadius = 22
        SearchIngredientLabel.layer.borderWidth = 0.2
        SearchIngredientLabel.layer.masksToBounds = true
        
        //Bo tron goc cho cac nut luu hoac huy thay doi
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 22
        
        //Khong hien thi vach chia cac cell
        IngredientTableView.separatorStyle = .none
        IngredientTableView.allowsSelection = false
        FirebaseRef.child("IngredientList").observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let arr = temp.value as? NSArray {
                    var check = false
                    for ingredient in self.SelectedIngredient {
                        //Nhung nguyen lieu nao da co roi thi de phia tren cua danh sach
                        if (ingredient.ID == Int(temp.key)) {
                            self.IngredientList.insert(contentsOf: [(ID: ingredient.ID, Name: arr[0] as! String, Value: ingredient.Value, Unit: arr[1] as! String)], at: 0)
                            check = true
                            break
                        }
                    }
                    //Nhung nguyen lieu nao chua co roi thi de phia duoi cua danh sach
                    if (check == false) {
                        self.IngredientList += [(ID: Int(temp.key)!, Name: arr[0] as! String, Value: 0, Unit: arr[1] as! String)]
                    }
                }
            }
            self.ReloadData()
        })
    }

    @IBAction func act_Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_Save(_ sender: Any) {
        delegate?.SaveChange()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_EditIngredient(_ sender: Any) {
        ButtonState = 1
        CurrentEditRow = (sender as! UIButton).tag
        ReloadData()
    }
    
    @IBAction func act_CancelIngredient(_ sender: Any) {
        ButtonState = 2
        ReloadData()
    }
    
    @IBAction func act_SaveIngredient(_ sender: Any) {
        ButtonState = 3
        ReloadData()
    }
    
    @IBAction func act_SearchIngredient(_ sender: Any) {
        //Lay chuoi trong khung tim kiem
        let name = SearchTextField.text!
        //Bo dau trong chuoi
        searchFoodName = name.folding(options: .diacriticInsensitive, locale: .current)
        //Viet thuong ten tim kiem
        searchFoodName = searchFoodName.lowercased()
        ReloadData()
    }
    
    @IBAction func act_DeleteSearch(_ sender: Any) {
        //Xoa chu trong khung tim kiem
        searchFoodName = ""
        SearchTextField.text = ""
        ReloadData()
    }
    
    func ReloadData() {
        //Reset mang chi so
        IngredientIndexList = [Int]()
        for index in 0..<IngredientList.count {
            //Neu ten nguyen lieu co chi so index chua chuoi can tim thi them vao list
            if (CheckIfStringContainSubstring(IngredientList[index].Name, searchFoodName) == true) {
                IngredientIndexList += [index]
            }
        }
        IngredientTableView.reloadData()
    }
    
}

extension IngredientListViewController : UITableViewDataSource, UITableViewDelegate {
    //So dong
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientIndexList.count
    }
    
    //Cai dat, hien thi du lieu 1 dong
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IngredientTableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        let index = IngredientIndexList[indexPath.row]
        
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.EditIngredientButton.tag = indexPath.row
        cell.EditIngredientButton.addTarget(self, action: #selector(act_EditIngredient), for: .touchUpInside)
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.SaveIngredientButton.addTarget(self, action: #selector(act_SaveIngredient), for: .touchUpInside)
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.CancelIngredientButton.addTarget(self, action: #selector(act_CancelIngredient), for: .touchUpInside)
        
        //Thay doi mau duong gach nhap so luong
        cell.DashLabel.backgroundColor = ColorScheme
        
        //Xu ly nguyen lieu dang duoc Edit
        if (indexPath.row == CurrentEditRow) {
            //Kiem tra cac trang thai va xu ly tuong ung
            if (ButtonState == 1) { //Nhan nut Edit
                //Vo hieu hoa nut Edit
                cell.EditIngredientButton.isHidden = true
                cell.EditIngredientButton.isEnabled = false
                //Hien thi nut Cancel
                cell.CancelIngredientButton.isHidden = false
                cell.CancelIngredientButton.isEnabled = true
                //Hien thi nut Save
                cell.SaveIngredientButton.isHidden = false
                cell.SaveIngredientButton.isEnabled = true
                //thut le phai
                cell.UnitTrailingConstraint.constant = 65
                cell.NumberWidthConstraint.constant = 50
                //Hien thi o nhap gia tri
                cell.IngredientNumberTextField.isEnabled = true
                cell.DashLabel.isHidden = false
            }
            else if (ButtonState != 0) {
                //Hien thi nut Edit
                cell.EditIngredientButton.isHidden = false
                cell.EditIngredientButton.isEnabled = true
                //Vo hieu hoa nut Cancel
                cell.CancelIngredientButton.isHidden = true
                cell.CancelIngredientButton.isEnabled = false
                //Vo hieu hoa nut Save
                cell.SaveIngredientButton.isHidden = true
                cell.SaveIngredientButton.isEnabled = false
                //Khong thut le phai
                cell.UnitTrailingConstraint.constant = 35
                cell.NumberWidthConstraint.constant = 85
                
                //Nhan nut Cancel
                if (ButtonState == 2) {
                    //Do nothing
                }
                else { //Nhan nut Save
                    if let temp = Double(cell.IngredientNumberTextField.text!) { IngredientList[index].Value = temp
                        //Truyen du lieu gia tri vua thay doi cua nguyen lieu
                        let ingre = IngredientList[index]
                        delegate?.UpdateIngredient(ingredient: (ID: ingre.ID, Name: ingre.Name, Value: temp, Unit: ingre.Unit))
                    }
                }
                
                //An o nhap gia tri
                cell.IngredientNumberTextField.isEnabled = false
                cell.DashLabel.isHidden = true
                
                //Ve trang thai ban dau
                ButtonState = 0
                CurrentEditRow = -1
            }
        }
        else { //Xu ly cac nguyen lieu khong duoc Edit
            //Tat cac nut Edit con lai neu dang Edit 1 nguyen lieu nao do
            if (ButtonState == 1) {
                cell.EditIngredientButton.isHidden = true
                cell.EditIngredientButton.isEnabled = false
            }
            else {
                cell.EditIngredientButton.isHidden = false
                cell.EditIngredientButton.isEnabled = true
            }
            
        }
        
        //Hien thi ten nguyen lieu
        cell.IngredientNameLabel.attributedText = AttributedStringWithColor(IngredientList[index].Name, searchFoodName, color: UIColor.link)
        
        //Hien thi gia tri cua nguyen lieu
        //So thuc
        if (Double(Int(IngredientList[index].Value)) != IngredientList[index].Value) {
            cell.IngredientNumberTextField.text = String(IngredientList[index].Value)
        }
        else { //So nguyen
            cell.IngredientNumberTextField.text = String(Int(IngredientList[index].Value))
        }
        //Hien thi don vi cua nguyen lieu
        cell.IngredientUnitLabel.text = IngredientList[index].Unit
        
        return cell
    }
}
