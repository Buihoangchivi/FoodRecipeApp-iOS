//
//  TestViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/2/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class TestViewController: UIViewController {

    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var GoogleSignUpButton: UIButton!
    @IBOutlet weak var FacebookSignUpButton: UIButton!
    
    @IBOutlet weak var UsernameNotificationLabel: UILabel!
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init();
        
        //Cài ảnh nền cho view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "user-background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.4
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func Init() {
        //Khoi tao mau app
        FirebaseRef.child("Setting").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            self.RegisterButton.backgroundColor = UIColor(named: "\(food["Color"]!)")
            }})
        //Doi mau chu goi y trong cac o nhap ten nguoi dung, email, mat khau
        UsernameTextField.attributedPlaceholder = NSAttributedString(string: "Tên đăng nhập", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Địa chỉ email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho cac o
        UsernameTextField.setLeftPaddingPoints(8)
        EmailTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        
        //Bo tron goc cho nut Dang ky, dang ky bang Google va dang ky bang Facebook
        RegisterButton.layer.cornerRadius = RegisterButton.frame.height / 2
        GoogleSignUpButton.layer.cornerRadius = GoogleSignUpButton.frame.height / 2
        FacebookSignUpButton.layer.cornerRadius = FacebookSignUpButton.frame.height / 2
        //Bo tron 3 khung nhap username, email va mat khau
        UsernameTextField.layer.cornerRadius = UsernameTextField.frame.height / 2
        UsernameTextField.layer.masksToBounds = true
        EmailTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        EmailTextField.layer.masksToBounds = true
        PasswordTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        PasswordTextField.layer.masksToBounds = true
        
        //Thay doi mau dong chu 'Đăng nhập nào' de lam noi bat
        let FirstTitle = NSAttributedString(string: "Bạn đã có tài khoản rồi? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let LastTitle = NSAttributedString(string: "Đăng nhập nào.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        let Title = NSMutableAttributedString()
        Title.append(FirstTitle)
        Title.append(LastTitle)
        SignInButton.setAttributedTitle(Title, for: UIControl.State.normal)
        
        //Dang nhap bang Google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
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
            ShowLoginButton()
        }
        else if (UsernameTextField.text!.isAlphanumeric == false) { //Cac ki tu chi chua cac chu cai tieng Anh va so
            ChangTextFieldState(UsernameTextField, UIColor.red, UsernameNotificationLabel, "Vui lòng tạo tên đăng nhập chỉ với số và các ký tự ASCII.")
            ShowLoginButton()
        }
        else {
            CheckIfUsernameIsExist(UsernameTextField.text!) { (isTaken) in
                if (isTaken == true) { //Kiem tra xem username da ton tai hay chua
                    ChangTextFieldState(self.UsernameTextField, UIColor.red, self.UsernameNotificationLabel, "Tên đăng nhập đã tồn tại.")
                }
                else { //Ten nguoi dung hop le
                    ChangTextFieldState(self.UsernameTextField, UIColor.systemGreen, self.UsernameNotificationLabel, "Tên đăng nhập hợp lệ.")
                }
                self.ShowLoginButton()
            }
        }
        
    }
    
    @IBAction func act_CheckValidEmail(_ sender: Any) {
        
        //Email co dinh dang hop le hay khong
        if (CheckIfEmailIsValid(EmailTextField.text!) == false) {
            ChangTextFieldState(EmailTextField, UIColor.red, EmailNotificationLabel, "Email có định dạng không hợp lệ.")
            ShowLoginButton()
        }
        else {
            CheckIfEmailIsExist(EmailTextField.text!) { (isTaken) in
                if (isTaken == true) { //Kiem tra xem email da ton tai hay chua
                    ChangTextFieldState(self.EmailTextField, UIColor.red, self.EmailNotificationLabel, "Email đã tồn tại.")
                }
                else { //Email hop le
                    ChangTextFieldState(self.EmailTextField, UIColor.systemGreen, self.EmailNotificationLabel, "Email hợp lệ.")
                }
                self.ShowLoginButton()
            }
        }
        
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
                
                //Username
                FirebaseRef.child("UserList/\(result!.user.uid)/Username").setValue(self.UsernameTextField.text!)
                //Email
                FirebaseRef.child("UserList/\(result!.user.uid)/Email").setValue(self.EmailTextField.text!)
                
                //Chuyen qua man hinh dang ky
                self.act_Login(sender)
            }
        }
        
    }
    
    @IBAction func act_CheckWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func act_CheckWithFacebook(_ sender: Any) {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        try! Auth.auth().signOut()
        
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
               
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
        
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
               
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                   
                    return
                }
                
                //Ten
                FirebaseRef.child("UserList/\(authResult!.user.uid)/DisplayName").setValue(authResult!.user.displayName)
                //Email
                FirebaseRef.child("UserList/\(authResult!.user.uid)/Email").setValue(authResult!.user.email)
                //Luu thong tin dang nhap
                CurrentUsername = authResult!.user.uid
                
                //Hien thi man hinh trang chu cua ung dung
                let dest = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
                   
                })
        
            }
        
    }
    
    @IBAction func act_Login(_ sender: Any) {
        /*let dest = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)*/
        self.dismiss(animated: true, completion: nil)
    }
}

extension TestViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
          print(error)
          return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        //print(credential)
        
        //Authenticate with Firebase using the credential
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            //Ten
            FirebaseRef.child("UserList/\(authResult!.user.uid)/DisplayName").setValue(authResult!.user.displayName)
            //Email
            FirebaseRef.child("UserList/\(authResult!.user.uid)/Email").setValue(authResult!.user.email)
            //Luu thong tin dang nhap
            CurrentUsername = authResult!.user.uid
            
            //Hien thi man hinh trang chu cua ung dung
            let dest = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(dest, animated: true, completion: nil)
            
        }
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    //iOS 8 or older
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}
