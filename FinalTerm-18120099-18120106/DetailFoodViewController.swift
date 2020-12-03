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
    
    var pickerView = UIPickerView()
    
    var arrIngre:Array<String> = []
    var number = [Int]()
    var arrIngreInfo = [String]()
    var FoodID = 0
    var NumberOfPeople = 0
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
                            self.arrIngre.append(infoArr[0])
                            self.arrIngreInfo.append(infoArr[1])
                            let num = arr[1] as! Int
                            self.number.append(num)
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
    
    @IBAction func btnProcessing(_ sender: Any) {
        let src = self.storyboard?.instantiateViewController(identifier: "ProcessingView") as! ProcessingViewController
        src.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        src.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(src, animated: true, completion: nil)
    }
    
    @IBAction func act_Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension DetailFoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIngre.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailIngredientCell") as! DetailIngredientFoodTableViewCell
        cell.lbIngre.text = arrIngre[indexPath.row]
        cell.lbNum.text = "\(number[indexPath.row])"
        cell.lbUnit.text = arrIngreInfo[indexPath.row]
        return cell
    }
}
