//
//  TipDetailViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/6/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class TipDetailViewController: UIViewController {

    @IBOutlet weak var TipImageView: UIImageView!
    
    @IBOutlet weak var LbTipDetail: UILabel!
    @IBOutlet weak var LbTipName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
