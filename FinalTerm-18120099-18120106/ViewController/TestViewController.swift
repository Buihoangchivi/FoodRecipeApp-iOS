//
//  TestViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/2/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var UsernameNotificationLabel: UILabel!
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init();
    }
    
    func Init() {
        //Doi mau chu goi y trong cac o nhap ten nguoi dung, email, mat khau
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Tài khoản email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho cac o
        UsernameTextField.setLeftPaddingPoints(8)
        EmailTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        
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
    
    @IBAction func act_CheckValidUsername(_ sender: Any) {
        //Ten dang nhap phai it nhat chua 2 ky tu
        if (UsernameTextField.text!.count < 2) {
            UsernameNotificationLabel.text = "Tên đăng nhập quá ngắn (tối thiểu là 2 ký tự)."
            UsernameNotificationLabel.textColor = UIColor.red
        }
        else if (UsernameTextField.text!.isAlphanumeric == false) { //Cac ki tu chi chua cac chu cai tieng Anh va so
            UsernameNotificationLabel.text = "Vui lòng tạo tên đăng nhập chỉ với số và các ký tự ASCII."
            UsernameNotificationLabel.textColor = UIColor.red
        }
        else if (CheckIfUsernameIsExist(UsernameTextField.text!) == true) { //Kiem tra xem username da ton tai hay chua
            UsernameNotificationLabel.text = "Tên đăng nhập đã tồn tại."
            UsernameNotificationLabel.textColor = UIColor.red
        }
        else { //Ten nguoi dung hop le
            UsernameNotificationLabel.text = "Tên đăng nhập hợp lệ."
            UsernameNotificationLabel.textColor = UIColor.systemGreen
        }
    }
    
    @IBAction func act_CheckValidEmail(_ sender: Any) {
        //Email co dinh dang hop le hay khong
        if (CheckIfEmailIsValid(EmailTextField.text!) == false) {
            EmailNotificationLabel.text = "Email có định dạng không hợp lệ."
            EmailNotificationLabel.textColor = UIColor.red
        }
        else if (CheckIfEmailIsExist(EmailTextField.text!) == true) { //Kiem tra xem email da ton tai hay chua
            EmailNotificationLabel.text = "Email đã tồn tại."
            EmailNotificationLabel.textColor = UIColor.red
        }
        else { //Email hop le
            EmailNotificationLabel.text = "Email hợp lệ."
            EmailNotificationLabel.textColor = UIColor.systemGreen
        }
    }
    
    @IBAction func act_CheckValidPassword(_ sender: Any) {
        //Mat khau phai chua it nhat chua 8 ky tu
        if (PasswordTextField.text!.count < 8) {
            PasswordNotificationLabel.text = "Mật khẩu quá ngắn (tối thiểu là 8 ký tự)."
            PasswordNotificationLabel.textColor = UIColor.red
        }
        else if (CheckIfPasswordIsValid(PasswordTextField.text!) == false) {
            //Mat khau phai chua it nhat 1 ky tu thuong, 1 ky tu in hoa va 1 so
            PasswordNotificationLabel.text = "Mật khẩu phải chứa ít nhất 1 chữ thường, 1 chữ in và 1 số."
            PasswordNotificationLabel.textColor = UIColor.red
        }
        else { //Mat khau hop le
            PasswordNotificationLabel.text = "Mật khẩu hợp lệ."
            PasswordNotificationLabel.textColor = UIColor.systemGreen
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
    @IBAction func act_Check(_ sender: Any) {
    }
    
    @IBAction func act_CheckWithGoogle(_ sender: Any) {
    }
    
    @IBAction func act_CheckWithFacebook(_ sender: Any) {
    }
    
    @IBAction func act_Login(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
    }
}
