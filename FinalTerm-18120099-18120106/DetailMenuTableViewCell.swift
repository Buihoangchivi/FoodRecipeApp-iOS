//
//  DetailMenuTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/28/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class DetailMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var btnLove: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var FoodNameLb: UILabel!
    @IBOutlet weak var FoodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 12
        FoodImageView.layer.cornerRadius = FoodImageView.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
