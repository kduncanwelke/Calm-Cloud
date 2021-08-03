//
//  PhotoManager.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

struct PhotoManager {
    static var loadedPhotos: [Photo] = []
    static var photos: [UIImage] = []
    static var currentPhotoIndex = 0

    static var image: UIImage?
}
