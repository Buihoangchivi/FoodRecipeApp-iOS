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
    override func viewDidLoad() {
        super.viewDidLoad()
        //Khoi tao mau app
        HeaderLb.backgroundColor = ColorScheme
        
        ColorCV.delegate = self
        ColorCV.dataSource = self
        // Do any additional setup after loading the view.
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
