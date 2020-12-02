//
//  IngredientTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/1/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var IngredientNameLabel: UILabel!
    @IBOutlet weak var IngredientNumberTextField: UITextField!
    @IBOutlet weak var IngredientUnitLabel: UILabel!
    @IBOutlet weak var DashLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
