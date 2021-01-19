//
//  ContactViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 1/19/21.
//  Copyright © 2021 Bui Van Vi. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var HeaderLb: UILabel!
    @IBOutlet weak var CopyrightLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        CopyrightLb.text = "Copyright \u{00A9} 2021"
        HeaderLb.backgroundColor = ColorScheme
        // Do any additional setup after loading the view.
    }
    
    @IBAction func act_Back(_ sender: Any) {
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
