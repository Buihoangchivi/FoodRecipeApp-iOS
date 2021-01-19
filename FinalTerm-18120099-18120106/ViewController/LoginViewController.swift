//
//  LoginViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/31/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var ForgetPasswordButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HidePasswordButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var GoogleSignInButton: UIButton!
    @IBOutlet weak var FacebookSignInButton: UIButton!
    
    @IBOutlet weak var EmailNotificationLabel: UILabel!
    @IBOutlet weak var PasswordNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init();
    }
    
    func Init() {
        
        //Cài ảnh nền cho view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "user-background")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.4
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Doi mau chu goi y trong cac o nhap ten nguoi dung va mat khau
        EmailTextField.attributedPlaceholder = NSAttributedString(string: "Địa chỉ email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Mật khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //Canh le cho 2 o Username va Password
        EmailTextField.setLeftPaddingPoints(8)
        PasswordTextField.setLeftPaddingPoints(8)
        PasswordTextField.setRightPaddingPoints(45)
        
        //Bo tron goc cho nut Dang nhap, dang nhap bang Google va dang nhap bang Facebook
        LoginButton.layer.cornerRadius = LoginButton.frame.height / 2
        GoogleSignInButton.layer.cornerRadius = GoogleSignInButton.frame.height / 2
        FacebookSignInButton.layer.cornerRadius = FacebookSignInButton.frame.height / 2
        //Bo tron 2 khung nhap email va mat khau
        EmailTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        EmailTextField.layer.masksToBounds = true
        PasswordTextField.layer.cornerRadius = EmailTextField.frame.height / 2
        PasswordTextField.layer.masksToBounds = true
        
        //Thay doi mau dong chu 'Đăng ký ngay' de lam noi bat
        let FirstTitle = NSAttributedString(string: "Bạn chưa có tài khoản? ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let LastTitle = NSAttributedString(string: "Đăng ký ngay.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen])
        let Title = NSMutableAttributedString()
        Title.append(FirstTitle)
        Title.append(LastTitle)
        RegisterButton.setAttributedTitle(Title, for: UIControl.State.normal)
        
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
                let dest = self.storyboard?.instantiateViewController(identifier: "SplashViewController") as! SplashViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func act_BackToStartUpScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_ResetPassword(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_Register(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! TestViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_LoginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func act_LoginWithFacebook(_ sender: Any) {
        
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
                let dest = self.storyboard?.instantiateViewController(identifier: "SplashViewController") as! SplashViewController
                dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(dest, animated: true, completion: nil)
                   
                })
        
            }
        
        /*// Sign out from Google
        GIDSignIn.sharedInstance().signOut()
        
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
            
            // Update screen after user successfully signed out
            //updateScreen()
        } catch let error as NSError {
            print ("Error signing out from Firebase: %@", error)
        }*/
    }
}

extension LoginViewController: GIDSignInDelegate {
    
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
            let dest = self.storyboard?.instantiateViewController(identifier: "SplashViewController") as! SplashViewController
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
