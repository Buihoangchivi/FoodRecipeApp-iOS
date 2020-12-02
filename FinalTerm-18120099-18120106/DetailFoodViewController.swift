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
class DetailFoodViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    
   
   
    @IBOutlet weak var FoodImageView: UIImageView!
    @IBOutlet weak var FoodNameLabel: UILabel!
   
    @IBOutlet weak var txtRation: UITextField!
    @IBOutlet weak var tbl_height: NSLayoutConstraint!
 
    @IBOutlet weak var IngredientTBV: UITableView!
    
    @IBOutlet weak var btnAddtoMenu: UIButton!
    
    @IBOutlet weak var btnAddIngre: UIButton!
    var NumberOfPeopleList = ["1","2","3","4","5","6","7","8","9","10"]
    var pickerView = UIPickerView()
    
    var arrIngre:Array<String> = []
    var number = [Int]()
    var arrIngreInfo = [String]()
    var FoodID = 0
    var test = ["1","2","3","4","5","6","7","8","9","10"]
    var NumberofPeople:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        INIT()
        IngredientTBV.delegate = self
        IngredientTBV.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        txtRation.inputView = pickerView
        txtRation.textAlignment = .center
        btnAddIngre.layer.cornerRadius = 20
        btnAddtoMenu.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize")
        {
                if let newvalue = change?[.newKey]{
                    let newsize = newvalue as! CGSize
                    self.tbl_height.constant = newsize.height
                }
        }
    }
    func INIT(){
          let index = 1
        foodInfoRef.child("\(index)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            self.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(food["Image"]!)"), placeholderImage: UIImage(named: "food-background"))
            if (self.FoodImageView.image != UIImage(named: "food-background")){
                //Bo tron goc cho hinh anh mon an
                self.FoodImageView.layer.cornerRadius = 100
                self.FoodImageView.layer.borderWidth = 1
                self.FoodImageView.layer.borderColor = UIColor.lightGray.cgColor
            }
            self.FoodNameLabel.text = "\(food["Name"]!)"
            }})
          foodInfoRef.child("\(index)/Ingredient").observeSingleEvent(of: .value, with: { (snapshot) in
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
                              print("\(infoArr[0]): \(arr[1]) \(infoArr[1])")
                              DispatchQueue.main.async {
                                            self.IngredientTBV.reloadData()
                                            print(self.arrIngre.count)
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return NumberOfPeopleList.count
       }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return NumberOfPeopleList[row]
       }
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           txtRation.text = NumberOfPeopleList[row]
           txtRation.resignFirstResponder()
       }
}
extension DetailFoodViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIngre.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailIngredientCell") as! DetailIngredientFoodTableViewCell
        cell.lbIngre.text = arrIngre[indexPath.row] + ":"
        cell.lbNum.text = "\(number[indexPath.row])"
        cell.lbUnit.text = arrIngreInfo[indexPath.row]
        return cell
    }
}
