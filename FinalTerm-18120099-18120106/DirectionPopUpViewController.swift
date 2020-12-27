//
//  DirectionPopUpViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/4/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

protocol DirectionPopUpDelegate: class {
    func DirectionProcess(index: Int, content: String)
}

class DirectionPopUpViewController: UIViewController {

    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var StepNumberLabel: UILabel!
    @IBOutlet weak var DirectionDetailTextView: UITextView!
    
    @IBOutlet weak var CancelDirectionButton: UIButton!
    @IBOutlet weak var SaveDirectionButton: UIButton!
    
    var DỉrectionID = 0
    var DirectionContent = ""
    var isAddNewDirection = false
    var delegate: DirectionPopUpDelegate?
    
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
        
        //Bo tron goc cho 2 nut Huy va Luu/Sua
        CancelDirectionButton.layer.cornerRadius = 22
        CancelDirectionButton.layer.borderColor = UIColor.systemGreen.cgColor
        CancelDirectionButton.layer.borderWidth = 1
        SaveDirectionButton.layer.cornerRadius = 22
        
        //Hien thi buoc thu may
        StepNumberLabel.text = "Bước \(DỉrectionID + 1)"
        DirectionDetailTextView.layer.borderWidth = 0.8
        DirectionDetailTextView.layer.borderColor = UIColor.systemGray.cgColor
        
        //Che do chinh sua buoc thuc hien
        if (isAddNewDirection == false) {
            //Hien thi noi dung cua buoc can chinh sua
            DirectionDetailTextView.text = DirectionContent
        }
        else { //Che do them buoc moi
            SaveDirectionButton.setTitle("Thêm", for: .normal)
        }
        
    }
    
    @IBAction func act_PopUpBackgroundButton(_ sender: Any) {
        act_CancelChange(sender)
    }
    
    @IBAction func act_CancelChange(_ sender: Any) {
        delegate?.DirectionProcess(index: -1, content: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_SaveChange(_ sender: Any) {
        delegate?.DirectionProcess(index: DỉrectionID, content: DirectionDetailTextView.text!)
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
