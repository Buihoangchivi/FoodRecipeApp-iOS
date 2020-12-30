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
    var isUserFood = false
    var FoodList = [(ID: Int, Name: String, ImageName: String, Favorite: Bool)]()
    var FoodsIndexList = [Int]()
    var Ref = DatabaseReference()
    var folderName = ""
    var searchFoodName = ""
    @IBOutlet weak var FoodListTBV: UITableView!
    @IBOutlet weak var SearchFoodsButton: UIButton!
    @IBOutlet weak var CancelFoodsButton: UIButton!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var SearchWidthConstraint: NSLayoutConstraint!
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
        //Hien thi danh sach cac mon an rieng do nguoi dung tu them
        if (isUserFood == true) {
            Ref = FirebaseRef.child("UserList")
            folderName = "/UserImages"
            CategoryNameLb.text = "Công thức nhà mình"
        }
        else { //Hien thi danh sach mon an chung
            Ref = foodInfoRef
            folderName = "/FoodImages"
            if (isFavorite == true) { //Hiển thị món ăn yêu thích
                CategoryNameLb.text = "Món ăn yêu thích"
            }
            else { //Hiển thị danh sách món ăn thuộc các loại khác
                CategoryNameLb.text = CategoryList[CategoryID]
            }
        }
        
        //Bo tron goc cho khung tim kiem
        SearchLabel.layer.cornerRadius = 22
        SearchLabel.layer.borderWidth = 0.2
        SearchLabel.layer.masksToBounds = true
        
        Ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                var check = false
                let temp = snapshotChild as! DataSnapshot
                if let food = temp.value as? [String:AnyObject] {
                    //Truong hop hien thi danh sach mon an cua ca nhan nguoi dung tu them
                    if (self.isUserFood == true) {
                        check = true
                    }
                    else {
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
                    }
                //Neu thoa ca loai mon an va loai bua an thi dua mon an do vao List
                if (check == true) {
                    let id = Int(temp.key)!
                    self.FoodList += [(ID: id, Name: "\(food["Name"]!)", ImageName: "\(food["Image"]!)", Favorite: food["Favorite"] as! Bool)]
                }
            }
        }
        DispatchQueue.main.async {
            self.ReloadData()
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
            FoodList[foodID].Favorite = true
            button.tintColor = UIColor.red
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //Cap nhat data tren Firebase
            Ref.child("\(FoodList[foodID].ID)").updateChildValues(["Favorite": 1])
            
        }
        else { //Xoa khoi danh sach yeu thich
            FoodList[foodID].Favorite = false
            button.tintColor = UIColor.black
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            //Cap nhat data tren Firebase
            Ref.child("\(FoodList[foodID].ID)").updateChildValues(["Favorite": 0])
            //Nếu đang hiển thị danh sách yêu thích thì cập nhật lại dữ liệu món ăn trên màn hình
            if (isFavorite == true) {
                FoodList.remove(at: foodID)
                FoodListTBV.reloadData()
            }
        }
    }
    
    @IBAction func act_OpenSearchBox(_ sender: Any) {
        //Vo hieu tieu de va nut tim kiem
        CategoryNameLb.isHidden = true
        CategoryNameLb.isEnabled = false
        SearchButton.isHidden = true
        SearchButton.isEnabled = false
        
        //Hien thi khung tim kiem
        SearchLabel.isHidden = false
        SearchTextField.text = ""
        SearchTextField.isHidden = false
        SearchTextField.isEnabled = true
        SearchFoodsButton.isHidden = false
        SearchFoodsButton.isEnabled = true
        CancelFoodsButton.isHidden = false
        CancelFoodsButton.isEnabled = true
        //Animation xuat hien khung tim kiem
        SearchWidthConstraint.constant += 265
        UIView.animate(withDuration: 1,
                       delay: 0,
                     animations: {
                        [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func act_SearchFoods(_ sender: Any) {
        //Lay chuoi trong khung tim kiem
        searchFoodName = SearchTextField.text!
        ReloadData()
    }
    
    @IBAction func act_CloseSearchBox(_ sender: Any) {
        searchFoodName = ""
        //An khung tim kiem
        SearchLabel.isHidden = true
        SearchTextField.isHidden = true
        SearchTextField.isEnabled = false
        SearchFoodsButton.isHidden = true
        SearchFoodsButton.isEnabled = false
        CancelFoodsButton.isHidden = true
        CancelFoodsButton.isEnabled = false
        //Active tieu de va nut tim kiem
        CategoryNameLb.isHidden = false
        CategoryNameLb.isEnabled = true
        SearchButton.isHidden = false
        SearchButton.isEnabled = true
        //Thu nho thanh tim kiem
        SearchWidthConstraint.constant -= 265
        ReloadData()
    }
    
    func ReloadData() {
        //Reset mang chi so
        FoodsIndexList = [Int]()
        for index in 0..<FoodList.count {
            //Neu ten meo hay co chi so index chua chuoi can tim thi them vao list
            if (CheckIfStringContainSubstring(FoodList[index].Name, searchFoodName) == true) {
                FoodsIndexList += [index]
            }
        }
        FoodListTBV.reloadData()
    }

}
extension DetailMenuViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FoodsIndexList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMenuCell") as! DetailMenuTableViewCell
        let index = FoodsIndexList[indexPath.row]
        //Gán chỉ số hàng tương ứng vào nút yêu thích của từng món ăn
        cell.btnLove.tag = indexPath.row
        cell.btnLove.addTarget(self, action: #selector(btnLove(_:)), for: .touchUpInside)
        //Hiển thị ảnh món ăn
        cell.FoodImageView.sd_setImage(with: imageRef.child("\(folderName)/\(FoodList[index].ImageName)"), maxImageSize: 1 << 30, placeholderImage: UIImage(named: "food-background"), options: .retryFailed, completion: nil)
        //Hiển thị tên món ăn
        cell.FoodNameLb.attributedText = AttributedStringWithColor(FoodList[index].Name, searchFoodName, color: UIColor.link)
        //Hiển thị trạng thái yêu thích của món ăn
        if (FoodList[index].Favorite == true) { //Yêu thích
            cell.btnLove.tintColor = UIColor.red
            cell.btnLove.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else { //Khong yeu thich
            cell.btnLove.tintColor = UIColor.black
            cell.btnLove.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "DetailFoodViewController") as! DetailFoodViewController
        let index = FoodsIndexList[indexPath.row]
        dest.FoodID = FoodList[index].ID
        dest.Ref = Ref
        dest.folderName = folderName
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
