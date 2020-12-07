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
    var count = 0
    
    var TipList = [(Name: String, Detail: String, ImageName: String)]()
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
            self.TipListTBV.reloadData()
        })
        TipListTBV.delegate = self
        TipListTBV.dataSource = self
        //Khong hien thi dau ngan cach giua cac o
        TipListTBV.separatorStyle = .none
    }
    
    @IBAction func act_Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TipList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipListCell") as! TipListTableViewCell
        cell.cellView.layer.cornerRadius = 10
        cell.TipImageView.layer.cornerRadius = 10
        cell.cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.cellView.layer.shadowOpacity = 1
        cell.cellView.layer.shadowOffset = .zero
        cell.cellView.layer.shadowRadius = 5
        
        //Xoa cache
        //Hien thi hinh anh mo ta meo
        cell.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(TipList[indexPath.row].ImageName)"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        //Hien thi ten meo
        cell.lbTip.text = TipList[indexPath.row].Name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "TipDetail") as! TipDetailViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(dest,animated: true,completion: nil)
       
        //Xoa cache
        //Hien thi hinh anh mo ta meo
        dest.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(TipList[indexPath.row].ImageName)"), maxImageSize: 1 << 30, placeholderImage: nil, options: .retryFailed, completion: nil)
        //Hien thi ten meo
        dest.LbTipName.text = TipList[indexPath.row].Name
        //Hien thi chi tiet noi dung meo
        dest.LbTipDetail.text = TipList[indexPath.row].Detail
        //Bo chon o
        TipListTBV.deselectRow(at: indexPath, animated: true)
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
