//
//  LoginViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/31/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var UsernameNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init();
    }
    
    func Init() {
        //Doi mau chu goi y trong cac o nhap ten nguoi dung va mat khau
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "Địa chỉ email hoặc tên đăng nhập", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho 2 o Username va Password
        UsernameTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        
        //Bo tron goc cho nut Dang nhap
        LoginButton.layer.cornerRadius = 4.5
        
        //Thay doi mau dong chu 'Đăng ký ngay' de lam noi bat
        let FirstTitle = NSAttributedString(string: "Bạn chưa có tài khoản? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        let LastTitle = NSAttributedString(string: "Đăng ký ngay.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        let Title = NSMutableAttributedString()
        Title.append(FirstTitle)
        Title.append(LastTitle)
        RegisterButton.setAttributedTitle(Title, for: UIControl.State.normal)
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
    
    @IBAction func act_CheckValidUsername(_ sender: Any) {
        //Kiểm tra username hoặc email có tồn tại hay chưa
        if (CheckIfUsernameIsExist(UsernameTextField.text!) == false && CheckIfEmailIsExist(UsernameTextField.text!) == false) {
            ChangTextFieldState(UsernameTextField, UIColor.red, UsernameNotificationLabel, "Địa chỉ email hoặc tên đăng nhập không tồn tại.")
        }
        else {
            ChangTextFieldState(UsernameTextField, UIColor.systemGreen, UsernameNotificationLabel, "Địa chỉ email hoặc tên đăng nhập hợp lệ.")
        }
        ShowLoginButton()
    }
    
    @IBAction func act_CheckValidPassword(_ sender: Any) {
        //Kiểm tra mật khẩu có đúng hay không
        if (CheckIfPasswordIsCorrect(UsernameTextField.text!, PasswordTextField.text!) == false) {
            ChangTextFieldState(PasswordTextField, UIColor.red, PasswordNotificationLabel, "Mật khẩu không chính xác.")
        }
        else {
            ChangTextFieldState(PasswordTextField, UIColor.systemGreen, PasswordNotificationLabel, "Mật khẩu chính xác.")
        }
        ShowLoginButton()
    }
    
    @IBAction func act_Login(_ sender: Any) {
    }
    
    @IBAction func act_ResetPassword(_ sender: Any) {
    }
    
    @IBAction func act_Register(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! TestViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_LoginWithGoogle(_ sender: Any) {
    }
    
    @IBAction func act_LoginWithFacebook(_ sender: Any) {
    }
    
    func ShowLoginButton() {
        //Hien nut dang ky
        if (UsernameNotificationLabel.textColor == UIColor.systemGreen &&
            PasswordNotificationLabel.textColor == UIColor.systemGreen) {
            LoginButton.alpha = 1
            LoginButton.isEnabled = true
        }
        else { //An nut dang ky
            LoginButton.alpha = 0.45
            LoginButton.isEnabled = false
        }
    }
}
