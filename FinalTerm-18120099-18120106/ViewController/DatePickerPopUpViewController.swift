//
//  DatePickerPopUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/8/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class DatePickerPopUpViewController: UIViewController {

    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var ChooseButton: UIButton!
    @IBOutlet weak var CloseButton: UIButton!
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    @IBOutlet weak var VerticalConstraint: NSLayoutConstraint!
    
    var delegate: DatePickerDalegate?
    var DefaultDate = Date()
    
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
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Khoi tao mau app
        FirebaseRef.child("Setting").observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            self.ChooseButton.backgroundColor = UIColor(named: "\(food["Color"]!)")
            self.CancelButton.layer.borderColor = UIColor(named: "\(food["Color"]!)")?.cgColor
            self.CancelButton.setTitleColor(UIColor(named: "\(food["Color"]!)"), for: .normal)
            }})
        
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
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderWidth = 1
        ChooseButton.layer.cornerRadius = 22
        
        //Bo tron cho nut Close
        CloseButton.layer.cornerRadius = 15

        //Hien thi ngay mac dinh cho DatePicker
        self.DatePicker.setDate(self.DefaultDate, animated: true)
    }
    
    @IBAction func act_ClosePopUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_ChooseDate(_ sender: Any) {
        delegate?.TransmitDate(Date: DatePicker!.date)
        self.dismiss(animated: true, completion: nil)
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

