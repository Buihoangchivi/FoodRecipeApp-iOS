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
    
   
   
    @IBOutlet weak var FoodImageView: UIImageView!
    
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var NumberPersonLabel: UILabel!
 
    @IBOutlet weak var IngredientTBV: UITableView!
    
    @IBOutlet weak var btnAddtoMenu: UIButton!
    @IBOutlet weak var btnAddIngre: UIButton!
    @IBOutlet weak var IngredientButton: UIButton!
    @IBOutlet weak var ProcessingButton: UIButton!
    @IBOutlet weak var DownNumberButton: UIButton!
    @IBOutlet weak var UpNumberButton: UIButton!
    
    var pickerView = UIPickerView()
    
    var TempSelectedIngredient = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var SelectedIngredientList = [(ID: Int, Name: String, Value: Double, Unit: String)]()
    var FoodID = 0
    var NumberOfPeople = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Bo tron goc cho cac nut
        btnAddtoMenu.layer.cornerRadius = 22
        btnAddIngre.layer.cornerRadius = 22
        btnAddIngre.layer.borderColor = UIColor.systemGreen.cgColor
        btnAddIngre.layer.borderWidth = 1
        IngredientButton.layer.cornerRadius = 10
        ProcessingButton.layer.cornerRadius = 10
        
        //An dau ngan cach giua cac TableViewCell
        IngredientTBV.separatorStyle = .none
        //Khong cho chon cell
        IngredientTBV.allowsSelection = false
        
        //Xu ly 2 nut tang giam khau phan an
        if (NumberOfPeople == 1) {
            DownNumberButton.isEnabled = false
        }
        else if (NumberOfPeople == 10) {
            UpNumberButton.isEnabled = false
        }
        foodInfoRef.child("\(FoodID)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            self.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(food["Image"]!)"), placeholderImage: UIImage(named: "food-background"))
            self.FoodNameLabel.text = "\(food["Name"]!)"
            }})
        foodInfoRef.child("\(FoodID)/Ingredient").observeSingleEvent(of: .value, with: { (snapshot) in
                for snapshotChild in snapshot.children {
                    let temp = snapshotChild as! DataSnapshot
                        if let arr = temp.value as? NSArray {
                            var infoArr = [String]()
                            foodInfoRef.child("IngredientList/\(arr[0])").observeSingleEvent(of: .value, with: { (snapshot) in
                                for snapshotChild in snapshot.children {
                                    let temp = snapshotChild as! DataSnapshot
                                    infoArr += [temp.value as! String]
                                }
                                self.SelectedIngredientList += [(ID: arr[0] as! Int, Name: infoArr[0], Value: arr[1] as! Double, Unit: infoArr[1])]
                            DispatchQueue.main.async {
                                self.IngredientTBV.reloadData()
                            }
                            })
                      }
                }
          })
      }
    
    
    @IBAction func btnAddtoMenu(_ sender: Any) {
    }
    
    @IBAction func btnAddIngredient(_ sender: Any) {
    }
    
    @IBAction func act_EditIngredient(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "IngredientListViewController") as! IngredientListViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.SelectedIngredient = self.SelectedIngredientList
        TempSelectedIngredient = SelectedIngredientList
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func btnProcessing(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "ProcessingView") as! ProcessingViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_Back(_ sender: Any) {
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
        IngredientTBV.reloadData()
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
        IngredientTBV.reloadData()
    }
    
}

//Delegate
extension DetailFoodViewController : IngredientDelegate {
    func UpdateIngredient(ingredient: (ID: Int, Name: String, Value: Double, Unit: String)) {
        var check = false
        for i in 0..<SelectedIngredientList.count {
            if (SelectedIngredientList[i].ID == ingredient.ID) {
                TempSelectedIngredient[i] = ingredient
                check = true
            }
        }
        if (check == false) {
            TempSelectedIngredient += [ingredient]
        }
    }
    
    func SaveStatus(save: Bool) {
        if (save == true) {
            var i = 0
            while i < TempSelectedIngredient.count {
                if (TempSelectedIngredient[i].Value == 0) {
                    TempSelectedIngredient.remove(at: i)
                    i -= 1
                }
                i += 1
            }
            SelectedIngredientList = TempSelectedIngredient
            IngredientTBV.reloadData()
        }
    }
}

extension DetailFoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedIngredientList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
