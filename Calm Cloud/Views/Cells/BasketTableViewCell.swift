//
//  BasketTableViewCell.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/5/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var selectedNumber: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    // MARK: Variables
    
    weak var cellDelegate: QuantityChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        var intified = Int(stepper.value)
        selectedNumber.text = "\(intified)"
        
        self.cellDelegate?.didChangeQuantity(sender: self, number: intified)
    }
}
