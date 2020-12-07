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
    var TipList = [(Name: String, Detail: String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        INIT()
        TipListTBV.delegate = self
        TipListTBV.dataSource = self
        // Do any additional setup after loading the view.
    }
    func INIT(){
        /*foodInfoRef.child("TipList").observeSingleEvent(of: .value, with: { (snapshot) in
              for snapshotChild in snapshot.children {
                let temp = snapshotChild as! DataSnapshot
                if let arr = temp.value as? NSArray {
                    self.TipList += [(Name: arr[0] as! String, Detail: arr[1] as! String)]
                }
                
              }
                DispatchQueue.main.async {
                self.TipListTBV.reloadData()
                }
        })*/
        foodInfoRef.child("TipList").observeSingleEvent(of: .value, with: { (snapshot) in
            let temp = snapshot.value as! NSArray
            self.count = temp.count
            DispatchQueue.main.async {
                self.TipListTBV.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipListCell") as! TipListTableViewCell
        cell.cellView.layer.cornerRadius = 10
        cell.cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.cellView.layer.shadowOpacity = 1
        cell.cellView.layer.shadowOffset = .zero
        cell.cellView.layer.shadowRadius = 5
        foodInfoRef.child("TipList").child("\(indexPath.row)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
        cell.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(food["Picture"]!)"), placeholderImage: UIImage(named: "food-background"))
            cell.lbTip.text = food["0"] as? String
        }})
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let src = storyboard?.instantiateViewController(withIdentifier: "TipDetail") as! TipDetailViewController
        src.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        src.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(src,animated: true,completion: nil)
        foodInfoRef.child("TipList").child("\(indexPath.row)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
        src.TipImageView.sd_setImage(with: imageRef.child("/TipImages/\(food["Picture"]!)"), placeholderImage: UIImage(named: "food-background"))
            src.LbTipDetail.text = food["1"] as? String
            src.LbTipName.text = food["0"] as? String
        }})
        
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
