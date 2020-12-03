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
    
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    
    @IBOutlet weak var tbView: UITableView!
    
    var DirectionList = [String]()
    var FoodID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
       
        //An dau ngan cach giua cac TableViewCell
        tbView.separatorStyle = .none
        //Khong cho chon cell
        tbView.allowsSelection = false
        
        foodInfoRef.child("\(FoodID)").observeSingleEvent(of: .value, with: { (snapshot) in
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
        foodInfoRef.child("\(FoodID)/Direction").observeSingleEvent(of: .value, with: { (snapshot) in
                for snapshotChild in snapshot.children {
                    let temp = snapshotChild as! DataSnapshot
                    self.DirectionList += [temp.value as! String]
                    }
                DispatchQueue.main.async {
                    self.tbView.reloadData()
                }
        })
    }
    
    @IBAction func act_ShowIngredient(_ sender: Any) {
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DirectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingCell") as! ProcessingTableViewCell
        cell.lbStep.text = "Bước \(indexPath.row + 1)"
        cell.lbDetail.text = "\(DirectionList[indexPath.row])"
        return cell
    }
}
