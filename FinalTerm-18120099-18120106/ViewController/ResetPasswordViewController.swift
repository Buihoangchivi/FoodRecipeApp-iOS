//
//  ResetPasswordViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/4/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var ResetPasswordButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var NotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
    }

    func Init() {
        
        //Cài ảnh nền cho view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "user-background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.4
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Doi mau chu goi y trong cac o email
        EmailTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Get Reset Email", comment: "Địa chỉ email sẽ nhận thư đặt lại mật khẩu"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le o nhap email
        EmailTextField.setLeftPaddingPoints(8)
        
        //Bo tron goc cho o nhap dia chi Email
        EmailTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        EmailTextField.layer.masksToBounds = true
        //Bo tron goc cho nut Dat lai mat khau
        ResetPasswordButton.layer.cornerRadius = ResetPasswordButton.frame.height / 2
        ResetPasswordButton.layer.masksToBounds = true
        
        //Thay doi mau dong chu 'Đăng nhập nào' de lam noi bat
        let FirstTitle = NSAttributedString(string: NSLocalizedString("Have an account", comment: "Bạn đã có tài khoản rồi? "), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let LastTitle = NSAttributedString(string: NSLocalizedString("Sign in now", comment: "Đăng nhập nào."), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        let Title = NSMutableAttributedString()
        Title.append(FirstTitle)
        Title.append(LastTitle)
        LoginButton.setAttributedTitle(Title, for: UIControl.State.normal)
    }
    
    @IBAction func act_CheckValidEmail(_ sender: Any) {
        
        //Email co dinh dang hop le hay khong
        if (CheckIfEmailIsValid(EmailTextField.text!) == false) {
            ChangTextFieldState(EmailTextField, UIColor.red, EmailNotificationLabel, NSLocalizedString("Email's format is wrong", comment: "Email có định dạng không hợp lệ."))
            ShowLoginButton()
        }
        else {
            CheckIfEmailIsExist(EmailTextField.text!) { (isTaken) in
                if (isTaken == true) { //Email hop le
                   
                    ChangTextFieldState(self.EmailTextField, UIColor.systemGreen, self.EmailNotificationLabel, NSLocalizedString("Valid email", comment: "Email hợp lệ."))
                    
                }
                else { //Email khong ung voi tai khoan nao
                    ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, NSLocalizedString("Email not exist", comment: "Không tìm thấy tài khoản nào tương ứng với email này."))
                }
                self.ShowLoginButton()
            }
        }
        
    }
    
    @IBAction func act_SendPasswordResetEmail(_ sender: Any) {
        
        //Gui email
        if (EmailTextField.isHidden == false) {
            //Gui email dat lại mat khau
            Auth.auth().sendPasswordReset(withEmail: EmailTextField.text!) { (error) in
                if (error != nil) {
                    print(error!)
                }
                else {
                    //An va vo hieu hoa khung nhap email
                    self.EmailTextField.isHidden = true
                    self.EmailTextField.isEnabled = false
                    //An thong bao ve email
                    self.EmailNotificationLabel.isHidden = true
                    //Hien thi thong bao cho nguoi dung
                    self.NotificationLabel.isHidden = false
                    //Hien thi nut quay tro ve man hinh dang nhap
                    self.ResetPasswordButton.setTitle(NSLocalizedString("Back to login", comment: "Trở về đăng nhập"), for: .normal)
                }
            }
        }
        else { //Da gui xong email va quay ve man hinh dang nhap
            act_Login(sender)
        }
        
    }
    
    @IBAction func act_Login(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func ShowLoginButton() {
        //Hien nut dat lai mat khau
        if (EmailNotificationLabel.textColor == UIColor.systemGreen) {
            ResetPasswordButton.alpha = 1
            ResetPasswordButton.isEnabled = true
        }
        else { //An nut dat lai mat khau
            ResetPasswordButton.alpha = 0.45
            ResetPasswordButton.isEnabled = false
        }
    }
}
