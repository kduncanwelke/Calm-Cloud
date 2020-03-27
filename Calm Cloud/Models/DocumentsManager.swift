//
//  DocumentsManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct DocumentsManager {
    static let fileManager = FileManager.default
    static let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var filePaths: [String] = []
}
