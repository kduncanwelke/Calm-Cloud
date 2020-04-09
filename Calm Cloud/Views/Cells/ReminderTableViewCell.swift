//
//  ReminderTableViewCell.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var cellDateOrRepeat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
