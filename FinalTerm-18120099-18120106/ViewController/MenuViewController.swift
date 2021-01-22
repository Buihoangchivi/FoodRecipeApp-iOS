//
//  MenuViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/2/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
class MenuViewController: UIViewController {
    
    @IBOutlet weak var MenuTBV: UITableView!
    
    @IBOutlet weak var MenuLb: UILabel!
    @IBOutlet weak var MenuRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var UserMailLb: UILabel!
    @IBOutlet weak var UserNameLb: UILabel!
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
        // Cập nhật thông tin user
        FirebaseRef.child("UserList/\(CurrentUsername)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let user = snapshot.value as? [String:Any] {
                
                let Name = user["DisplayName"] as? String
                let Name1 = user["Username"] as? String
                self.UserNameLb.text = Name ?? Name1
                let Mail = user["Email"] as? String
                self.UserMailLb.text = Mail
            }
            
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
            if (indexPath.row == 9)
            {
                let dest = self.storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
            }
            else {
                if(indexPath.row == 8)
                {
                    let dest = self.storyboard?.instantiateViewController(identifier: "ContactViewController") as! ContactViewController
                    dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(dest, animated: true, completion: nil)
                }
                else{
                    if(indexPath.row == 10)
                    {
                        let dest = self.storyboard?.instantiateViewController(identifier: "StartUpViewController") as! StartUpViewController
                        //Log out
                        if(LoginMethod == 0)
                        {
                            do {
                                try Auth.auth().signOut()
                                
                                // Update screen after user successfully signed out
                                //updateScreen()
                            } catch let error as NSError {
                                print ("Error signing out from Firebase: %@", error)
                            }
                        }
                        if(LoginMethod == 1)
                        {
                            GIDSignIn.sharedInstance().signOut()
                        }
                        if(LoginMethod == 2)
                        {
                            let fbLoginManager = LoginManager()
                            fbLoginManager.logOut()
                        }
                        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(dest, animated: true, completion: nil)
                    }
                    else{
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
        }}
        //Bo chon cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

