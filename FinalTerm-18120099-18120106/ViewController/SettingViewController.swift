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
        FirebaseRef.child("Setting").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
        self.HeaderLb.backgroundColor = UIColor(named: "\(food["Color"]!)")
            }})
        ColorCV.delegate = self
        ColorCV.dataSource = self
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        FirebaseRef.child("Setting").updateChildValues(["Color": ColorList[indexPath.row]])
        HeaderLb.backgroundColor = UIColor(named: ColorList[indexPath.row])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/5.3, height: collectionViewWidth/5.3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
