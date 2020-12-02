//
//  DetailIngredientFoodTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class DetailIngredientFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var lbNum: UILabel!
    @IBOutlet weak var lbIngre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
