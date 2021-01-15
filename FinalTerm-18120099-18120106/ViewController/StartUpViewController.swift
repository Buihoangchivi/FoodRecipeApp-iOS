//
//  StartUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/16/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {
    
    @IBOutlet weak var UserButton: UIButton!
    @IBOutlet weak var AdminButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Init()
    }
    
    func Init() {
        
        //Bo tròn góc cho 2 nút User và Admin
        UserButton.layer.cornerRadius = UserButton.frame.height / 2
        AdminButton.layer.cornerRadius = AdminButton.frame.height / 2
        
    }
    
    @IBAction func act_ChooseUserMode(_ sender: Any) {
        
        //Bat che do nguoi dung
        isUserMode = true
        
        //Hien thi man hinh dang nhap danh cho nguoi dung
        let dest = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
        
    }
    
    @IBAction func act_ChooseAdminMode(_ sender: Any) {
    }
    
}
