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
    var CategoryID = 0
    var isFavorite = false
    var FoodList = [(ID: Int, Name: String, ImageName: String, Favorite: Bool)]()
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
        FoodList = [(ID: Int, Name: String, ImageName: String, Favorite: Bool)]()
        if (isFavorite == true) { //Hiển thị món ăn yêu thích
            CategoryNameLb.text = "Món ăn yêu thích"
        }
        else { //Hiển thị danh sách món ăn thuộc các loại khác
            CategoryNameLb.text = CategoryList[CategoryID]
        }
        foodInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                var check = false
                let temp = snapshotChild as! DataSnapshot
                if let food = temp.value as? [String:AnyObject] {
                    //Truong hop hien thi danh sach yeu thich
                    if (self.isFavorite == true) {
                        check = food["Favorite"] as! Bool
                    }
                    else {
                        //Kiem tra co thoa loai mon an dang loc hay khong
                        if (food["Category"] != nil) {
                            let categoryArray = food["Category"] as! NSArray
                            for i in 0..<categoryArray.count {
                                if (categoryArray[i] as! Int == self.CategoryID) {
                                    check = true
                                    break
                                }
                            }
                        }
                    }
                //Neu thoa ca loai mon an va loai bua an thi dua mon an do vao List
                if (check == true) {
                    let id = Int(temp.key)!
                    self.FoodList += [(ID: id, Name: "\(food["Name"]!)", ImageName: "\(food["Image"]!)", Favorite: food["Favorite"] as! Bool)]
                }
            }
        }
        DispatchQueue.main.async {
            self.FoodListTBV.reloadData()
            self.FoodListTBV.isHidden = false
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
            foodInfoRef.child("\(FoodList[foodID].ID)").updateChildValues(["Favorite": 1])
            
        }
        else { //Xoa khoi danh sach yeu thich
            button.tintColor = UIColor.black
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            //Cap nhat data tren Firebase
            foodInfoRef.child("\(FoodList[foodID].ID)").updateChildValues(["Favorite": 0])
            //Nếu đang hiển thị danh sách yêu thích thì cập nhật lại dữ liệu món ăn trên màn hình
            if (isFavorite == true) {
                FoodList.remove(at: foodID)
                FoodListTBV.reloadData()
            }
        }
    }

}
extension DetailMenuViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMenuCell") as! DetailMenuTableViewCell
        cell.btnLove.tag = indexPath.row
        cell.btnLove.addTarget(self, action: #selector(btnLove(_:)), for: .touchUpInside)
        cell.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(FoodList[indexPath.row].ImageName)"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        cell.FoodNameLb.text = FoodList[indexPath.row].Name
        if (FoodList[indexPath.row].Favorite == true) {
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
        dest.FoodID = FoodList[indexPath.row].ID
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        present(dest, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DetailMenuViewController: DetailFoodDelegate {
    func Reload() {
        FoodListTBV.isHidden = true
        Init()
    }
}
