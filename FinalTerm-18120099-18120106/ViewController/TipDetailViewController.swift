//
//  TipDetailViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/6/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class TipDetailViewController: UIViewController {

    @IBOutlet weak var HeaderLb: UILabel!
    @IBOutlet weak var TipImageView: UIImageView!
    
    @IBOutlet weak var LbTipDetail: UILabel!
    @IBOutlet weak var LbTipName: UILabel!
    @IBOutlet weak var CircleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
    }
    func Init(){
        //Khoi tao mau app
        HeaderLb.backgroundColor = ColorScheme
        CircleImage.tintColor = ColorScheme
        
    }
            
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
