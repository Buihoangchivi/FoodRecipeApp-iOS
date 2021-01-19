//
//  SettingViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 1/14/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var HeaderLb: UILabel!
    @IBOutlet weak var ColorCV: UICollectionView!
    @IBOutlet weak var ShowSplashScreenButton: UIButton!
    
    var check = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
    }
    
    func Init() {
        
        //Khoi tao mau app
        HeaderLb.backgroundColor = ColorScheme
        
        ColorCV.delegate = self
        ColorCV.dataSource = self
        
        //Hien thi man hinh trang chu cua ung dung
        FirebaseRef.child("UserList/\(CurrentUsername)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let user = snapshot.value as? [String:Any] {
                
                if let isCheck = user["SplashScreen"] as? Int {
                    
                    if (isCheck == 1) { //Hiển thị SplashScreen
                        
                        self.ShowSplashScreenButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                        //FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 0])
                        
                    }
                    else { //Không hiển thị SplashScreen
                        
                        self.ShowSplashScreenButton.setImage(UIImage(systemName: "square"), for: .normal)
                        //FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 1])
                        
                    }
                    self.check = isCheck
                    
                }
                
            }
            
        })
        
    }

    @IBAction func act_ShowSplashScreen(_ sender: Any) {
        
        if (check == 0) { //Chuyển từ ẩn sang hiển thị SplashScreen
            
            self.ShowSplashScreenButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            check = 1
            FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 1])
            
        }
        else { //Chuyển từ hiển thị sang ẩn SplashScreen
            
            self.ShowSplashScreenButton.setImage(UIImage(systemName: "square"), for: .normal)
            check = 0
            FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["SplashScreen": 0])
            
        }
        
    }
    
    @IBAction func act_Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingCell", for: indexPath) as! SettingCollectionViewCell
        cell.backgroundColor = UIColor(named: ColorList[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //Cap nhat data tren Firebase
        ColorScheme = UIColor(named: ColorList[indexPath.row])!
        FirebaseRef.child("UserList/\(CurrentUsername)").updateChildValues(["Color": ColorList[indexPath.row]])
        HeaderLb.backgroundColor = ColorScheme
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/5.3, height: collectionViewWidth/5.3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
