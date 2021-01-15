//
//  AdminViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/16/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AdminViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        Init()
    }
    
    func Init() {
        
        //Doi mau chu goi y trong cac o nhap ten nguoi dung va mat khau
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Địa chỉ email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho 2 o Username va Password
        EmailTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        
        //Bo tron goc cho nut Dang nhap
        LoginButton.layer.cornerRadius = LoginButton.frame.height / 2
        
        //Bo tron 2 khung nhap email va mat khau
        EmailTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        EmailTextField.layer.masksToBounds = true
        PasswordTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        PasswordTextField.layer.masksToBounds = true
        
    }
    
    @IBAction func act_ChangePasswordVisibility(_ sender: Any) {
        //An mat khau
        if (HidePasswordButton.tintColor == UIColor.systemGreen) {
            HidePasswordButton.tintColor = UIColor.lightGray
            HidePasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            PasswordTextField.isSecureTextEntry = true
        }
        else { //Hien mat khau
            HidePasswordButton.tintColor = UIColor.systemGreen
            HidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
            PasswordTextField.isSecureTextEntry = false
        }
    }
    
    @IBAction func act_ShowLoginButton(_ sender: Any) {
        //Hien nut dang nhap
        if (EmailTextField.text! != "" && PasswordTextField.text! != "" && LoginButton.isEnabled == false) {
            LoginButton.isEnabled = true
            LoginButton.alpha = 1
        }
        else if ((EmailTextField.text! == "" || PasswordTextField.text! == "") && LoginButton.isEnabled == true) { //An nut dang nhap
            LoginButton.isEnabled = false
            LoginButton.alpha = 0.45
        }
    }
    
    @IBAction func act_Login(_ sender: Any) {
        //Khoa khung nhap email, mat khau va nut dang nhap
        EmailTextField.isEnabled = false
        EmailTextField.alpha = 0.5
        PasswordTextField.isEnabled = false
        PasswordTextField.alpha = 0.5
        LoginButton.isEnabled = false
        LoginButton.alpha = 0.45
        //Dang nhap
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (result, error) in
            //Mo khoa 2 khung nhap email va mat khau
            self.EmailTextField.isEnabled = true
            self.EmailTextField.alpha = 1
            self.PasswordTextField.isEnabled = true
            self.PasswordTextField.alpha = 1
            self.LoginButton.isEnabled = true
            self.LoginButton.alpha = 1
            
            //Kiem tra co loi hay khong
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidEmail:
                            ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, "Địa chỉ email không đúng định dạng.")
                            NormalizeTextFieldState(self.PasswordTextField, self.PasswordNotificationLabel)
                        case .wrongPassword:
                            ChangTextFieldState(self.EmailTextField, UIColor.systemGreen, self.EmailNotificationLabel, "")
                            ChangTextFieldState(self.PasswordTextField, UIColor.red, self.PasswordNotificationLabel, "Mật khẩu không chính xác.")
                        case .tooManyRequests:
                            ChangTextFieldState(self.EmailTextField, UIColor.systemGreen, self.EmailNotificationLabel, "")
                            ChangTextFieldState(self.PasswordTextField, UIColor.red, self.PasswordNotificationLabel, "Tạm thời khoá tài khoản này do truy cập lỗi quá nhiều lần.")
                        case .userDisabled:
                            ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, "Tài khoản này đã bị vô hiệu hoá.")
                        NormalizeTextFieldState(self.PasswordTextField, self.PasswordNotificationLabel)
                        default:
                            ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, "Địa chỉ email không hợp lệ.")
                            NormalizeTextFieldState(self.PasswordTextField, self.PasswordNotificationLabel)
                    }
                }
            }
            else {
                //Luu thong tin ten dang nhap
                CurrentUsername = result!.user.uid
                
                //Hien thi man hinh trang chu cua ung dung
                let dest = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
            }
        }
    }

    @IBAction func act_BackToStartUpScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
