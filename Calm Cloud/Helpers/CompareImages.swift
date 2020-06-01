//
//  CompareImages.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func isMatch(with images: [UIImage]) -> Bool {
        for image in images {
            if self.image?.pngData() == image.pngData() {
                return true
            }
        }
        
        return false
    }
}
