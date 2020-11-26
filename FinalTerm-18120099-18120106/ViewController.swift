//
//  ViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/26/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ShoppingButton: UIButton!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    
    let CategoryList = ["Thịt heo", "Thịt bò", "Thịt gà", "Hải sản", "Cá", "Bánh", "Trái cây", "Ăn chay", "Giảm cân", "Chiên xào", "Món canh", "Món nướng", "Món kho", "Món nhậu", "Tiết kiệm", "Ngày lễ, tết"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Init()
        // Do any additional setup after loading the view.
    }

    func Init() {
        let layout = CategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 8,left: 5,bottom: 7,right: 15)
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.CategoryLabel.text = CategoryList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
