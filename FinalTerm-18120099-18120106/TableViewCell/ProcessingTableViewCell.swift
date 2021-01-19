//
//  ProcessingTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/2/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ProcessingTableViewCell: UITableViewCell {

    @IBOutlet weak var lbDetail: UILabel!
    @IBOutlet weak var lbStep: UILabel!
    @IBOutlet weak var CircleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
