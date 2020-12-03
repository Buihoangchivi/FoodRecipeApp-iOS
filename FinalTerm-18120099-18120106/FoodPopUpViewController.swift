//
//  FoodPopUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/30/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class FoodPopUpViewController: UIViewController {

    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    @IBOutlet weak var DetailFoodButton: UIButton!
    @IBOutlet weak var ChooseFoodButton: UIButton!
    @IBOutlet weak var CloseButton: UIButton!
    
    var FoodID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Lam mo nen cua view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
        
        //Bo tron goc cua Pop-up
        PopUpView.layer.cornerRadius = 10
        
        //Bo tron goc cho 2 nut Chi tiet va Chon mon
        DetailFoodButton.layer.cornerRadius = 22
        DetailFoodButton.layer.borderColor = UIColor.systemGreen.cgColor
        DetailFoodButton.layer.borderWidth = 1
        ChooseFoodButton.layer.cornerRadius = 22
        
        //Bo tron cho nut Close
        CloseButton.layer.cornerRadius = 15
        
        //Load anh va ten mon an
        foodInfoRef.child("\(FoodID)").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            self.FoodImageView.sd_setImage(with: imageRef.child("/FoodImages/\(food["Image"]!)"), placeholderImage: UIImage(named: "food-background"))
            if (self.FoodImageView.image != UIImage(named: "food-background")){
                //Bo tron goc cho hinh anh mon an
                self.FoodImageView.layer.cornerRadius = 100
                self.FoodImageView.layer.borderWidth = 1
                self.FoodImageView.layer.borderColor = UIColor.lightGray.cgColor
            }
            self.FoodNameLabel.text = "\(food["Name"]!)"
            }})
    }
    
    @IBAction func act_PopUpBackgroundButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_ClosePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_ShowDetailFood(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "DetailFoodViewController") as! DetailFoodViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.FoodID = FoodID
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_ChooseFood(_ sender: Any) {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
