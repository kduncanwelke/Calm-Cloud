//
//  ActivityTableViewCell.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/9/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellCategoryLabel: UILabel!
    @IBOutlet weak var cellCheckButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
