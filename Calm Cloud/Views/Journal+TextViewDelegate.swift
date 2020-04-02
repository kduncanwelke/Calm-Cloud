//
//  Journal+TextViewDelegate.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/2/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

extension JournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Start typing . . ." {
            textView.text = nil
        }
    }
    
    // reassign placeholder if empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Start typing . . ."
        }
    }
}
