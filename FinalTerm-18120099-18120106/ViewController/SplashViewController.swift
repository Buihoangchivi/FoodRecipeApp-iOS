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
    var imageID = 0
    let checkedImage = UIImage(named: "checked") as! UIImage
    let uncheckedImage = UIImage(named: "uncheck") as! UIImage
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
        // Do any additional setup after loading the view.
    }
    func Init(){
        //Random hinh anh hien len
        imageID = Int.random(in: 1..<7)
        SplashImage.image = UIImage(named: "Splash\(imageID)")
        imageID = imageID - 1
        //Chinh border cho UIView
        TipView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.white, thickness: 2)
        TipView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 2)
        // Bo tron va chinh mau cho button Continue
        Continue.layer.cornerRadius = 22
        Continue.layer.backgroundColor = UIColor(named: "BlueColor")?.cgColor
        btnCheck.setImage(uncheckedImage, for: .normal)
        // Random meo hay
    FirebaseRef.child("Setting/\(imageID)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let food = snapshot.value as? [String:Any] {
                   //Hien thi ten meo
                self.TipLb.text = "\(food["Name"]!)"
                print("\(food["Name"]!)")
                self.TipDetailLb.text = "\(food["Detail"]!)"
                   }})
            // Set hinh anh cho checkbox
            btnCheck.setImage(uncheckedImage, for: .normal)
    }
    @IBAction func act_Check(_ sender: Any) {
        let button = sender as! UIButton
               //Cap nhat tren firebase
        if (checkID == 0) {
            button.setImage(checkedImage, for: .normal)
            checkID = 1
            FirebaseRef.child("Setting").updateChildValues(["SplashScreen": 1])
            }
        else {
            button.setImage(uncheckedImage, for: .normal)
            checkID = 0
            FirebaseRef.child("Setting").updateChildValues(["SplashScreen": 0])
        }
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
