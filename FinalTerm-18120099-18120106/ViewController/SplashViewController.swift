//
//  SplashViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 1/15/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SplashViewController: UIViewController {
    var checkID = 0
    var splashID = 0
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var SplashImage: UIImageView!
    @IBOutlet weak var Continue: UIButton!
    @IBOutlet weak var TipLb: UILabel!
    @IBOutlet weak var TipView: UIView!
    @IBOutlet weak var TipDetailLb: UILabel!
    @IBOutlet weak var ShowLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
    }
    
    func Init() {
        
        //Random hinh anh hien len
        splashID = Int.random(in: 0..<5)
        
        //Chinh border cho UIView
        TipView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.white, thickness: 2)
        TipView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 2)
        
        // Bo tron cho nut Continue
        Continue.layer.cornerRadius = Continue.frame.height / 2
        
        // Random meo hay
        FirebaseRef.child("Setting/\(splashID)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let splashInfo = snapshot.value as? [String:Any] {
                
                //Hien thi ten meo
                self.TipLb.text = "\(splashInfo["Name"]!)"
                
                //Hiển thị mô tả mẹo
                self.TipDetailLb.text = "\(splashInfo["Detail"]!)"
                
                //Hiển thị ảnh của mẹo
                self.SplashImage.sd_setImage(with: imageRef.child("/SettingImages/\(splashInfo["Image"]!)"), maxImageSize: 1 << 30, placeholderImage: UIImage(), options: .retryFailed, completion: nil)
                
            }
        })
        
    }
    
    @IBAction func act_Check(_ sender: Any) {
        
        //Cap nhat tren firebase
        if (checkID == 0) { //Không hiện SplashScreen nữa
            
            btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkID = 1
            FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 0])
            
        }
        else { //Tiếp tục hiện SplashScreen trong lần sau
            
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            checkID = 0
            FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 1])
            
        }
        
    }
    
    @IBAction func act_ShowLoginScreen(_ sender: Any) {
        
        //Hiển thị màn hình trang chủ
        let dest = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
        
    }
    
}
extension CALayer{
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat)
    {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
