//
//  MenuViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/2/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var MenuList = ["Món ăn yêu thích","Công thức nhà mình","Mẹo hay","Món ăn ngày lễ","Món ăn chay","Món ăn giảm cân","Món bánh ngon","Món nhậu cơ bản", "Chính sách quyền riêng tư","Liên hệ","Cài đặt"]
    @IBOutlet weak var MenuTBV: UITableView!
    
    @IBOutlet weak var MenuLb: UILabel!
    @IBOutlet weak var MenuRightConstraint: NSLayoutConstraint!
    
    var delegate: ReloadDataDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        MenuRightConstraint.constant += view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MenuRightConstraint.constant -= view.bounds.width
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        self.MenuTBV.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Khoi tao mau app
        FirebaseRef.child("UserList/\(CurrentUsername)/Color").observe(.value, with: { (snapshot) in
                
                self.MenuLb.textColor = ColorScheme
                
        })
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
    }

    @IBAction func act_HideMenu(_ sender: Any) {
        MenuRightConstraint.constant += view.bounds.width
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
            }, completion: {(value: Bool) in
                self.delegate?.Reload()
                self.dismiss(animated: true, completion: nil)
        }
        )
        
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

extension MenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        cell.lbMenu.text = MenuList[indexPath.row]
        cell.btnMenu.setImage(UIImage(named: "menu\(indexPath.row + 1)"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Meo hay
        if (indexPath.row == 2) {
            let dest = self.storyboard?.instantiateViewController(identifier: "TipListViewController") as! TipListViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(dest, animated: true, completion: nil)
        }
        else {
            if (indexPath.row == 10)
            {
                let dest = self.storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
            }
            else {
            let dest = self.storyboard?.instantiateViewController(identifier: "DetailMenuViewController") as! DetailMenuViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            switch indexPath.row {
            case 0: //Món ăn yêu thích
                dest.isFavorite = true
            case 1: //Công thức nhà mình
                dest.isUserFood = true
            case 3: //Món ăn ngày lễ
                dest.CategoryID = 16
            case 4: //Món ăn chay
                dest.CategoryID = 8
            case 5: //Món ăn giảm cân
                dest.CategoryID = 9
            case 6: //Món bánh ngon
                dest.CategoryID = 6
            case 7: //Món nhậu cơ bản
                dest.CategoryID = 14
            default: //Truong hop mac dinh
                dest.CategoryID = 0
            }
            self.present(dest, animated: true, completion: nil)
            }
        }
        //Bo chon cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
