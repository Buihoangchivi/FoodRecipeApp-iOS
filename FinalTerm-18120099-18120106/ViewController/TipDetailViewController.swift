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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
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
