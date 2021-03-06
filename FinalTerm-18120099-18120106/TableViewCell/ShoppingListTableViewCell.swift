//
//  ShoppingListTableViewCell.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/9/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var IngredientNameLabel: UILabel!
    @IBOutlet weak var ValueAndUnitLabel: UILabel!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var UncheckButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var CircleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DeleteButton.layer.cornerRadius = 12
        CircleImageView.tintColor = ColorScheme
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
