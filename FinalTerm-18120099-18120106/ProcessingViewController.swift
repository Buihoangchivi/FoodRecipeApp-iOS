//
//  ProcessingViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase

class ProcessingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrIngre.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as! ProcessingTableViewCell
        let temp = arrIngre[indexPath.row] + ":  " + " " + arrIngreInfo[indexPath.row]
        cell.lbDetail.text = temp
        cell.lbStep.text = "* Buoc \(indexPath.row + 1)"
        return cell
    }
    
   
    
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    var arrIngre = [String]()
    var arrIngreInfo = [String]()
    var number = [Int]()
    @IBOutlet weak var tbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        INIT()
        tbView.delegate = self
        tbView.dataSource = self
        // Do any additional setup after loading the view.
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
                                          self.tbView.reloadData()
                                          print(self.arrIngre.count)
                            }
                    })
                    }
                  
                    }
        })

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
