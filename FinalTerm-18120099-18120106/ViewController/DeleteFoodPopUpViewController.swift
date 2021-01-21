//
//  DeleteFoodPopUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 1/20/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class DeleteFoodPopUpViewController: UIViewController {
    //Outlet
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var CloseButton: UIButton!
    
    @IBOutlet weak var VerticalConstraint: NSLayoutConstraint!
    
    var FoodName = ""
    var FoodID = -1
    var Ref = foodInfoRef
    
    var delegate: DeleteFoodDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        VerticalConstraint.constant += view.bounds.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        VerticalConstraint.constant -= view.bounds.height
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
    }
    
    func Init() {
        //Khoi tao mau app
        DeleteButton.backgroundColor = ColorScheme
        CancelButton.layer.borderColor = ColorScheme.cgColor
        CancelButton.setTitleColor(ColorScheme, for: .normal)
        FoodNameLabel.textColor = ColorScheme
        
        //Khoi tao ten mon an
        FoodNameLabel.text = FoodName
        
        //Lam mo nen cua view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
        
        //Bo tron goc cua Pop-up
        PopUpView.layer.cornerRadius = 10
        
        //Bo tron goc cho 2 nut Huy va Chon ngay
        CancelButton.layer.cornerRadius = CancelButton.frame.height / 2
        CancelButton.layer.borderWidth = 1
        DeleteButton.layer.cornerRadius = DeleteButton.frame.height / 2
        
        //Bo tron cho nut Close
        CloseButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func act_ClosePopUp(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func act_DeleteFood(_ sender: Any) {
        
        //Xoá dữ liệu món ăn trên Firebase
        Ref.child("\(FoodID)").removeValue()
        
        //Đóng giao diện Popup
        self.dismiss(animated: true, completion: nil)
        delegate?.UpdateUI()
        
    }
    
}
