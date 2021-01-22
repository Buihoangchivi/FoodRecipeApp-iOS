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
        
        //Cài ảnh nền cho view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.45
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    
    @IBAction func act_ChooseUserMode(_ sender: Any) {
        
        //Bat che do nguoi dung
        isUserMode = true
        
        //Hien thi man hinh dang nhap danh cho nguoi dung
        let dest = self.storyboard?.instantiateViewController(identifier: Storyboard.Login_StoryboardID) as! LoginViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
        
    }
    
    @IBAction func act_ChooseAdminMode(_ sender: Any) {
        
        //Tat che do nguoi dung, bat che do quan tri vien
        isUserMode = false
        
        //Hien thi man hinh dang nhap danh cho nguoi dung
        let dest = self.storyboard?.instantiateViewController(identifier: Storyboard.Admin_StoryboardID) as! AdminViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
        
    }
    
}
