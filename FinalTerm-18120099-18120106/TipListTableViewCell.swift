//
//  TipListTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/5/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class TipListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbTip: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var TipImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
