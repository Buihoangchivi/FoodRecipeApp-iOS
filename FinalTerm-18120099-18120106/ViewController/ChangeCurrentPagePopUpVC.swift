//
//  ChangeCurrentPagePopUpVC.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/13/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ChangeCurrentPagePopUpVC: UIViewController {

    @IBOutlet weak var PopUpView: UIView!
    
    @IBOutlet weak var PagePickerView: UIPickerView!
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var ChooseButton: UIButton!
    
    var TotalPage = 0
    var CurrentPage = 0
    var PageSelectionArray = [Int]()
    var delegate: ChangeCurrentPagePopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()

        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Khoi tao mau app
        ChooseButton.backgroundColor = ColorScheme
        CancelButton.setTitleColor(ColorScheme, for: .normal)
        CancelButton.layer.borderColor = ColorScheme.cgColor
        
        //Lam mo nen cua view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
        
        //Bo tron goc cua Pop-up
        PopUpView.layer.cornerRadius = 10
        
        //Bo tron goc cho 2 nut Huy va Luu/Sua
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderWidth = 1
        ChooseButton.layer.cornerRadius = 22
        
        //Khoi tao cac trang cho mang
        for i in 1...TotalPage {
            PageSelectionArray += [i]
        }
        
        //Mac dinh chon trang hien tai
        PagePickerView.selectRow(CurrentPage - 1, inComponent: 0, animated: true)
    }
    
    @IBAction func act_PopUpBackgroundButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_CancelChange(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_SaveChange(_ sender: Any) {
        let selectedIndex = PageSelectionArray[PagePickerView.selectedRow(inComponent: 0)]
        if (selectedIndex != CurrentPage) {
            delegate?.UpdateCurrentPage(index: selectedIndex)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChangeCurrentPagePopUpVC : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PageSelectionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(PageSelectionArray[row])
    }
}
