//
//  FoodPopUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/30/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class FoodPopUpViewController: UIViewController {

    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    @IBOutlet weak var DetailFoodButton: UIButton!
    @IBOutlet weak var ChooseFoodButton: UIButton!
    @IBOutlet weak var CloseButton: UIButton!
    
    var FoodID = 0
    var delegate: ReloadDataDelegate?
    var isClickDetailFood = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Khoi tao mau app
        DetailFoodButton.backgroundColor = ColorScheme
        ChooseFoodButton.setTitleColor(ColorScheme, for: .normal)
        ChooseFoodButton.layer.borderColor = ColorScheme.cgColor
        
        //Lam mo nen cua view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
        
        //Bo tron goc cua Pop-up
        PopUpView.layer.cornerRadius = 10
        
        //Bo tron goc cho 2 nut Chi tiet va Chon mon
        DetailFoodButton.layer.cornerRadius = DetailFoodButton.frame.height / 2
        ChooseFoodButton.layer.borderWidth = 1
        ChooseFoodButton.layer.cornerRadius = ChooseFoodButton.frame.height / 2
        
        //Bo tron cho nut Close
        CloseButton.layer.cornerRadius = 15
        
        //Load anh va ten mon an
        foodInfoRef.child("\(FoodID)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            //Xoa cache
            //SDImageCache.shared.clearMemory()
            //SDImageCache.shared.clearDisk()
            
            self.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(food["Image"]!)"), maxImageSize: 1 << 30, placeholderImage: UIImage(named: "food-background"), options: .retryFailed) { (image, error, cacheType, url) in
                    if error == nil {
                    //Bo tron goc cho hinh anh mon an
                    self.FoodImageView.layer.cornerRadius = 100
                    self.FoodImageView.layer.borderWidth = 1
                    self.FoodImageView.layer.borderColor = UIColor.lightGray.cgColor
                    return
                }}
                
            self.FoodNameLabel.text = "\(food["Name"]!)"
            }})
        
        //Hiển thị nút "Chọn món" ở chế độ User
        if (isUserMode == true) {
            
            ChooseFoodButton.setTitle("Chọn món", for: .normal)
            
        }
        else { //Hiển thị nút "Xoá món" ở chế độ Admin
            
            ChooseFoodButton.setTitle("Xoá món", for: .normal)
            
        }
    }
    
    @IBAction func act_ClosePopUp(_ sender: Any) {
        //Neu co chon chi tiet mon an thi reload lai giao dien
        if (isClickDetailFood == true) {
            delegate?.Reload()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_ShowDetailFood(_ sender: Any) {
        isClickDetailFood = true
        let dest = self.storyboard?.instantiateViewController(identifier: "DetailFoodViewController") as! DetailFoodViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.FoodID = FoodID
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_ChooseFood(_ sender: Any) {
        
        //Chọn món ở chế độ User
        if (isUserMode == true) {
         
            let dest = self.storyboard?.instantiateViewController(identifier: "DatePickerPopUpViewController") as! DatePickerPopUpViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            self.present(dest, animated: true, completion: nil)
            
        }
        else { //Xoá món ở chế độ Admin
            
            let dest = self.storyboard?.instantiateViewController(identifier: "DeleteFoodPopUpViewController") as! DeleteFoodPopUpViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            dest.FoodName = FoodNameLabel.text!
            dest.FoodID = FoodID
            self.present(dest, animated: true, completion: nil)
            
        }
        
    }
}

extension FoodPopUpViewController: DatePickerDalegate{
    func TransmitDate(Date date: Date) {
        let path = DateToString(date, "yyyy/MM/dd")
        FirebaseRef.child("ShoppingList/\(path)").observeSingleEvent(of: .value) { (snapshot) in
            var index = 0
            var isExist = false
            if (snapshot.exists() == true) {
                for snapshotChild in snapshot.children {
                    let temp = snapshotChild as! DataSnapshot
                    if let info = temp.value as? [String:AnyObject] {
                        if self.FoodID == info["FoodID"] as! Int {
                            isExist = true
                            break
                        }
                    }
                }
                index = Int(snapshot.childrenCount)
            }
            
            if (isExist == false) {
            FirebaseRef.child("ShoppingList/\(path)/\(index)").setValue(["FoodID": self.FoodID])
            }
            }
    }
}


//Delegate cua man hinh PopUp xoa mon an sau khi xoa thanh cong
extension FoodPopUpViewController: DeleteFoodDelegate {
    
    func ReloadAfterDeleteFood() {
        
        delegate?.Reload()
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
