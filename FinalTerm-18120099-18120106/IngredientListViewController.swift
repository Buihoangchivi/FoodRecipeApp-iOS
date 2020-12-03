//
//  IngredientListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase

protocol IngredientDelegate : class {
    func UpdateIngredient(ingredient: (ID: Int, Name: String, Value: Double, Unit: String))
    func SaveStatus(save: Bool)
}

class IngredientListViewController: UIViewController {

    @IBOutlet weak var SearchIngredientLabel: UILabel!
    @IBOutlet weak var IngredientTableView: UITableView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    var IngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var SelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    //0 la khong chinh sua nguyen lieu nao ca
    //1 la nhan nut chinh sua nguyen lieu
    //2 la nhan nut huy chinh sua
    //3 la nhan nut luu chinh sua
    var ButtonState = 0
    var CurrentEditRow = -1
    var checkClickSave = false
    weak var delegate : IngredientDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Bo tron goc cho khung tim kiem
        SearchIngredientLabel.layer.cornerRadius = 22
        SearchIngredientLabel.layer.borderWidth = 0.2
        SearchIngredientLabel.layer.masksToBounds = true
        
        //Bo tron goc cho cac nut luu hoac huy thay doi
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderColor = UIColor.systemGreen.cgColor
        CancelButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 22
        
        //Khong hien thi vach chia cac cell
        IngredientTableView.separatorStyle = .none
        IngredientTableView.allowsSelection = false
        foodInfoRef.child("IngredientList").observeSingleEvent(of: .value, with: { (snapshot) in
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
            self.IngredientTableView.reloadData()
        })
    }

    @IBAction func act_Cancel(_ sender: Any) {
        delegate?.SaveStatus(save: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_Save(_ sender: Any) {
        delegate?.SaveStatus(save: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_EditIngredient(_ sender: Any) {
        ButtonState = 1
        CurrentEditRow = (sender as! UIButton).tag
        IngredientTableView.reloadData()
    }
    
    @IBAction func act_CancelIngredient(_ sender: Any) {
        ButtonState = 2
        IngredientTableView.reloadData()
    }
    
    @IBAction func act_SaveIngredient(_ sender: Any) {
        ButtonState = 3
        IngredientTableView.reloadData()
    }
    
}

extension IngredientListViewController : UITableViewDataSource, UITableViewDelegate {
    //So dong
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientList.count
    }
    
    //Cai dat, hien thi du lieu 1 dong
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IngredientTableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.EditIngredientButton.tag = indexPath.row
        cell.EditIngredientButton.addTarget(self, action: #selector(act_EditIngredient), for: .touchUpInside)
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.SaveIngredientButton.addTarget(self, action: #selector(act_SaveIngredient), for: .touchUpInside)
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.CancelIngredientButton.addTarget(self, action: #selector(act_CancelIngredient), for: .touchUpInside)
        
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
                    
                }
                else { //Nhan nut Save
                    if let temp = Double(cell.IngredientNumberTextField.text!) { IngredientList[indexPath.row].Value = temp
                        //Truyen du lieu gia tri vua thay doi cua nguyen lieu
                        let ingre = IngredientList[indexPath.row]
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
        cell.IngredientNameLabel.text = IngredientList[indexPath.row].Name
        //Hien thi gia tri cua nguyen lieu
        //So thuc
        if (Double(Int(IngredientList[indexPath.row].Value)) != IngredientList[indexPath.row].Value) {
            cell.IngredientNumberTextField.text = String(IngredientList[indexPath.row].Value)
        }
        else { //So nguyen
            cell.IngredientNumberTextField.text = String(Int(IngredientList[indexPath.row].Value))
        }
        //Hien thi don vi cua nguyen lieu
        cell.IngredientUnitLabel.text = IngredientList[indexPath.row].Unit
        
        return cell
    }
}
