//
//  PhotoViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/3/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class PhotoViewModel {

    func decreasePhotoIndex() -> Bool {
        if PhotoManager.currentPhotoIndex == 0 {
            return false
        } else {
            PhotoManager.currentPhotoIndex -= 1
            PhotoManager.image = PhotoManager.photos[PhotoManager.currentPhotoIndex]
            return true
        }
    }

    func increasePhotoIndex() -> Bool {
        if PhotoManager.currentPhotoIndex == PhotoManager.photos.count - 1 {
            return false
        } else {
            PhotoManager.currentPhotoIndex += 1
            PhotoManager.image = PhotoManager.photos[PhotoManager.currentPhotoIndex]
            return true
        }
    }

    func getPhoto() -> UIImage? {
        guard let imageToZoom = PhotoManager.image else { return nil }
        return imageToZoom
    }
}
