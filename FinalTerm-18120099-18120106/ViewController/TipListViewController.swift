//
//  TipListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/5/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
class TipListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TipListTBV: UITableView!
    @IBOutlet weak var SearchTipsButton: UIButton!
    @IBOutlet weak var CancelTipsButton: UIButton!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchLabel: UILabel!
    
    @IBOutlet weak var TipsLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var SearchWidthConstraint: NSLayoutConstraint!
    
    var count = 0
    var TipList = [(Name: String, Detail: String, ImageName: String)]()
    var TipsIndexList = [Int]()
    var searchFoodName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    func Init(){
        foodInfoRef.child("TipList").observeSingleEvent(of: .value, with: { (snapshot) in
              for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let dict = temp.value as? [String: Any] {
                    self.TipList += [(Name: dict["0"] as! String, Detail: dict["1"] as! String, ImageName: dict["Picture"] as! String)]
                }
              }
            self.ReloadData()
        })
        TipListTBV.delegate = self
        TipListTBV.dataSource = self
        //Khong hien thi dau ngan cach giua cac o
        TipListTBV.separatorStyle = .none
        
        //Bo tron goc cho khung tim kiem
        SearchLabel.layer.cornerRadius = 22
        SearchLabel.layer.borderWidth = 0.2
        SearchLabel.layer.masksToBounds = true
    }
    
    @IBAction func act_Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_OpenSearchBox(_ sender: Any) {
        //Vo hieu tieu de va nut tim kiem
        TipsLabel.isHidden = true
        TipsLabel.isEnabled = false
        SearchButton.isHidden = true
        SearchButton.isEnabled = false
        
        //Hien thi khung tim kiem
        SearchLabel.isHidden = false
        SearchTextField.text = ""
        SearchTextField.isHidden = false
        SearchTextField.isEnabled = true
        SearchTipsButton.isHidden = false
        SearchTipsButton.isEnabled = true
        CancelTipsButton.isHidden = false
        CancelTipsButton.isEnabled = true
        //Animation xuat hien khung tim kiem
        SearchWidthConstraint.constant += 265
        UIView.animate(withDuration: 1,
                       delay: 0,
                     animations: {
                        [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func act_SearchTips(_ sender: Any) {
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
        SearchTipsButton.isHidden = true
        SearchTipsButton.isEnabled = false
        CancelTipsButton.isHidden = true
        CancelTipsButton.isEnabled = false
        //Active tieu de va nut tim kiem
        TipsLabel.isHidden = false
        TipsLabel.isEnabled = true
        SearchButton.isHidden = false
        SearchButton.isEnabled = true
        //Thu nho thanh tim kiem
        SearchWidthConstraint.constant -= 265
        ReloadData()
    }
    
    func ReloadData() {
        //Reset mang chi so
        TipsIndexList = [Int]()
        for index in 0..<TipList.count {
            //Neu ten meo hay co chi so index chua chuoi can tim thi them vao list
            if (CheckIfStringContainSubstring(TipList[index].Name, searchFoodName) == true) {
                TipsIndexList += [index]
            }
        }
        TipListTBV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TipsIndexList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipListCell") as! TipListTableViewCell
        let index = TipsIndexList[indexPath.row]
        cell.cellView.layer.cornerRadius = 10
        cell.TipImageView.layer.cornerRadius = 10
        cell.cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.cellView.layer.shadowOpacity = 1
        cell.cellView.layer.shadowOffset = .zero
        cell.cellView.layer.shadowRadius = 5
        
        //Xoa cache
        //Hien thi hinh anh mo ta meo
        cell.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(TipList[index].ImageName)"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        //Hien thi ten meo
        cell.lbTip.attributedText = AttributedStringWithColor(TipList[index].Name, searchFoodName, color: UIColor.link)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "TipDetail") as! TipDetailViewController
        let index = TipsIndexList[indexPath.row]
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(dest,animated: true,completion: nil)
       
        //Xoa cache
        //Hien thi hinh anh mo ta meo
        dest.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(TipList[index].ImageName)"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        //Hien thi ten meo
        dest.LbTipName.text = TipList[index].Name
        //Hien thi chi tiet noi dung meo
        dest.LbTipDetail.text = TipList[index].Detail
        //Bo chon o
        TipListTBV.deselectRow(at: indexPath, animated: true)
    }

}
