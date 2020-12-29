//
//  EditDirectionTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/4/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class EditDirectionTableViewCell: UITableViewCell {

    @IBOutlet weak var StepNumberLabel: UILabel!
    @IBOutlet weak var StepDetailLabel: UILabel!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var WidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
