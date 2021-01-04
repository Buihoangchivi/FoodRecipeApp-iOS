//
//  TestViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/2/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import FirebaseAuth

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
            ChangTextFieldState(UsernameTextField, UIColor.red, UsernameNotificationLabel, "Tên đăng nhập quá ngắn (tối thiểu là 2 ký tự).")
        }
        else if (UsernameTextField.text!.isAlphanumeric == false) { //Cac ki tu chi chua cac chu cai tieng Anh va so
            ChangTextFieldState(UsernameTextField, UIColor.red, UsernameNotificationLabel, "Vui lòng tạo tên đăng nhập chỉ với số và các ký tự ASCII.")
        }
        else {
            CheckIfUsernameIsExist(UsernameTextField.text!) { (isTaken) in
                if (isTaken == true) { //Kiem tra xem username da ton tai hay chua
                    ChangTextFieldState(self.UsernameTextField, UIColor.red, self.UsernameNotificationLabel, "Tên đăng nhập đã tồn tại.")
                }
                else { //Ten nguoi dung hop le
                    ChangTextFieldState(self.UsernameTextField, UIColor.systemGreen, self.UsernameNotificationLabel, "Tên đăng nhập hợp lệ.")
                }
            }
        }
        
        ShowLoginButton()
    }
    
    @IBAction func act_CheckValidEmail(_ sender: Any) {
        //Email co dinh dang hop le hay khong
        if (CheckIfEmailIsValid(EmailTextField.text!) == false) {
            ChangTextFieldState(EmailTextField, UIColor.red, EmailNotificationLabel, "Email có định dạng không hợp lệ.")
        }
        else {
            CheckIfEmailIsExist(EmailTextField.text!) { (isTaken) in
                if (isTaken == true) { //Kiem tra xem email da ton tai hay chua
                    ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, "Email đã tồn tại.")
                }
                else { //Email hop le
                    ChangTextFieldState(self.EmailTextField, UIColor.systemGreen, self.EmailNotificationLabel, "Email hợp lệ.")
                }
            }
        }
        
        ShowLoginButton()
    }
    
    @IBAction func act_CheckValidPassword(_ sender: Any) {
        //Mat khau phai chua it nhat chua 8 ky tu
        if (PasswordTextField.text!.count < 8) {
            ChangTextFieldState(PasswordTextField, UIColor.red, PasswordNotificationLabel, "Mật khẩu quá ngắn (tối thiểu là 8 ký tự).")
        }
        else if (CheckIfPasswordIsValid(PasswordTextField.text!) == false) {
            //Mat khau phai chua it nhat 1 ky tu thuong, 1 ky tu in hoa va 1 so
            ChangTextFieldState(PasswordTextField, UIColor.red, PasswordNotificationLabel, "Mật khẩu phải chứa ít nhất 1 chữ thường, 1 chữ in và 1 số.")
        }
        else { //Mat khau hop le
            ChangTextFieldState(PasswordTextField, UIColor.systemGreen, PasswordNotificationLabel, "Mật khẩu hợp lệ.")
        }
        ShowLoginButton()
    }
    
    func ShowLoginButton() {
        //Hien nut dang ky
        if (UsernameNotificationLabel.textColor == UIColor.systemGreen &&
            EmailNotificationLabel.textColor == UIColor.systemGreen &&
            PasswordNotificationLabel.textColor == UIColor.systemGreen) {
            RegisterButton.alpha = 1
            RegisterButton.isEnabled = true
        }
        else { //An nut dang ky
            RegisterButton.alpha = 0.45
            RegisterButton.isEnabled = false
        }
    }
    
    //Tao tai khoan moi
    @IBAction func act_Check(_ sender: Any) {
        
        //Khoa khung nhap username, email, mat khau va nut dang ky
        UsernameTextField.isEnabled = false
        UsernameTextField.alpha = 0.5
        EmailTextField.isEnabled = false
        EmailTextField.alpha = 0.5
        PasswordTextField.isEnabled = false
        PasswordTextField.alpha = 0.5
        RegisterButton.isEnabled = false
        RegisterButton.alpha = 0.45
        
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (result, err) in
            
            //Mo khoa khung nhap username, email, mat khau va nut dang ky
            self.UsernameTextField.isEnabled = true
            self.UsernameTextField.alpha = 1
            self.EmailTextField.isEnabled = true
            self.EmailTextField.alpha = 1
            self.PasswordTextField.isEnabled = true
            self.PasswordTextField.alpha = 1
            self.RegisterButton.isEnabled = true
            self.RegisterButton.alpha = 1
            
            //Kiem tra co loi hay khong
            if err != nil {
                print(err!)
            }
            else {
                //UID
                FirebaseRef.child("UserList/\(self.UsernameTextField.text!)/UID").setValue(result!.user.uid)
                //Email
                FirebaseRef.child("UserList/\(self.UsernameTextField.text!)/Email").setValue(self.EmailTextField.text!)
                //Password
                FirebaseRef.child("UserList/\(self.UsernameTextField.text!)/Password").setValue(self.PasswordTextField.text!)
                
                //Chuyen qua man hinh dang ky
                self.act_Login(sender)
            }
        }
        
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
