//
//  RegisterViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/1/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var RetypePasswordTextField: UITextField!
    @IBOutlet weak var HideRetypePasswordButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var UsernameNotificationLabel: UILabel!
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!
    @IBOutlet weak var RetypePasswordNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init();
    }
    
    func Init() {
        //Doi mau chu goi y trong cac o nhap ten nguoi dung, email, mat khau, nhap lai mat khau
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "Tên người dùng", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Tài khoản email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        RetypePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Nhập lại mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho cac o
        UsernameTextField.setLeftPaddingPoints(8)
        EmailTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        RetypePasswordTextField.setLeftPaddingPoints(8)
        RetypePasswordTextField.setRightPaddingPoints(45)
        
        //Bo tron goc cho nut Dang ky
        RegisterButton.layer.cornerRadius = 4.5
        
        //Thay doi mau dong chu 'Đăng nhập nào' de lam noi bat
        let FirstTitle = NSAttributedString(string: "Bạn đã có tài khoản rồi? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        let LastTitle = NSAttributedString(string: "Đăng nhập nào.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        let Title = NSMutableAttributedString()
        Title.append(FirstTitle)
        Title.append(LastTitle)
        SignInButton.setAttributedTitle(Title, for: UIControl.State.normal)
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
        /*if (UsernameTextField.text != "" && PasswordTextField.text != "" && LoginButton.isEnabled == false) {
            LoginButton.alpha = 1
            LoginButton.isEnabled = true
        }
        //An nut dang nhap
        else if ((UsernameTextField.text == "" || PasswordTextField.text == "") && LoginButton.isEnabled == true) {
            LoginButton.alpha = 0.45
            LoginButton.isEnabled = false
        }*/
    }
    
    @IBAction func act_Register(_ sender: Any) {
    }
    
    @IBAction func act_Login(_ sender: Any) {
    }
    
    @IBAction func act_RegisterWithGoogle(_ sender: Any) {
    }
    
    @IBAction func act_RegisterWithFacebook(_ sender: Any) {
    }
}
