//
//  DetailMenuViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/28/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
class DetailMenuViewController: UIViewController {
    var DirectionList = [String]()
    var CategoryID = 3
    var FoodIDList = [Int]()
    var FoodImageOutletList = [String]()
    var FoodNameList = [String]()
    var FoodFavoriteList = [Bool]()
    @IBOutlet weak var FoodListTBV: UITableView!
    
    @IBOutlet weak var CategoryNameLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        FoodListTBV.delegate = self
        FoodListTBV.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        CategoryNameLb.text = CategoryList[CategoryID]
        foodInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                var check = 0
                let temp = snapshotChild as! DataSnapshot
                if let food = temp.value as? [String:AnyObject] {
                    //Kiem tra co thoa loai mon an dang loc hay khong
                    if (food["Category"] != nil) {
                        let categoryArray = food["Category"] as! NSArray
                        for i in 0..<categoryArray.count {
                            if (categoryArray[i] as! Int == self.CategoryID) {
                                check += 1
                                break
                            }
                        }
                    }
                //Neu thoa ca loai mon an va loai bua an thi dua mon an do vao List
                if (check == 1) {
                    let id = Int(temp.key)!
                    self.FoodIDList += [id]
                    self.FoodImageOutletList += ["\(food["Image"]!)"]
                    //Hien thi ten mon an
                    self.FoodNameList += ["\(food["Name"]!)"]
                    
                    //Hien thi trang thai yeu thich cua mon an
                    //Yeu thich
                    if (food["Favorite"] as! Int == 1) {
                        self.FoodFavoriteList += [true]
                    }
                    else { //Khong yeu thich
                        self.FoodFavoriteList += [false]
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.FoodListTBV.reloadData()
        }
    })
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLove(_ sender: Any) {
        let button = sender as! UIButton
        //Them vao danh sach yeu thich
        let foodID = (sender as! UIButton).tag
        if (button.tintColor == UIColor.black) {
            button.tintColor = UIColor.red
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //Cap nhat data tren Firebase
            foodInfoRef.child("\(FoodIDList[foodID])").updateChildValues(["Favorite": 1])
            
        }
        else { //Xoa khoi danh sach yeu thich
            button.tintColor = UIColor.black
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            //Cap nhat data tren Firebase
            foodInfoRef.child("\(FoodIDList[foodID])").updateChildValues(["Favorite": 0])
        }
    }

}
extension DetailMenuViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodIDList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMenuCell") as! DetailMenuTableViewCell
        cell.btnLove.tag = indexPath.row
        cell.btnLove.addTarget(self, action: #selector(btnLove(_:)), for: .touchUpInside)
        cell.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(FoodImageOutletList[indexPath.row])"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        cell.FoodNameLb.text = FoodNameList[indexPath.row]
        if (FoodFavoriteList[indexPath.row]) {
            cell.btnLove.tintColor = UIColor.red
            cell.btnLove.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else { //Khong yeu thich
            cell.btnLove.tintColor = UIColor.black
            cell.btnLove.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.btnLove.layer.cornerRadius = cell.btnLove.frame.height/2
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "DetailFoodViewController") as! DetailFoodViewController
        dest.FoodID = FoodIDList[indexPath.row]
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(dest, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
