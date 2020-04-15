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
    
    // MARK: Variables
    
    weak var cellDelegate: CellCheckDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: IBActions
    
    @IBAction func checkTapped(_ sender: UIButton) {
        var isChecked = false
        
        if sender.imageView?.image?.pngData() == UIImage(named: "incomplete")?.pngData() {
            sender.setImage(UIImage(named: "complete"), for: .normal)
            isChecked = true
        } else {
            sender.setImage(UIImage(named: "incomplete"), for: .normal)
            isChecked = false
        }
        
        self.cellDelegate?.didChangeSelectedState(sender: self, isChecked: isChecked)
    }
}
