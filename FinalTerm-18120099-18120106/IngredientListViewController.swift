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
    func UpdateIngredient(ingredient: (ID: Int, Value: Double))
}

class IngredientListViewController: UIViewController {

    @IBOutlet weak var SearchIngredientLabel: UILabel!
    @IBOutlet weak var IngredientTableView: UITableView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    var IngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var SelectedIngredient = [(ID: Int, Value: Double)]()
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
                        self.IngredientList += [(ID: Int(temp.key)!, Name: arr[0] as! String, Value: 0.0, Unit: arr[1] as! String)]
                    }
                }
            }
            self.IngredientTableView.reloadData()
        })
    }

    @IBAction func act_Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_Save(_ sender: Any) {
        //Danh dau da nhan nut luu va cap nhat du lieu vao mang
        checkClickSave = true
        SelectedIngredient = [(ID: Int, Value: Double)]()
        IngredientTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
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
        
        if (checkClickSave == false) {
            cell.IngredientNameLabel.text = IngredientList[indexPath.row].Name
            if (IngredientList[indexPath.row].Value != 0) {
                cell.IngredientNumberTextField.text = String(IngredientList[indexPath.row].Value)
            }
            cell.IngredientUnitLabel.text = IngredientList[indexPath.row].Unit
        }
        else { //Khi da nhan nut luu thi luu tat cac cac gia tri cua nguyen lieu vao mang
            if let temp = Double(cell.IngredientNumberTextField.text!) {
                delegate?.UpdateIngredient(ingredient: (ID: IngredientList[indexPath.row].ID, Value: temp))
            }
        }
        return cell
    }
}
