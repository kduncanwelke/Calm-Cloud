//
//  FavoritesViewModel.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 8/3/21.
//  Copyright © 2021 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class FavoritesViewModel {

    func setPhotoForSegue(tapped: UIImage?) {
        PhotoManager.image = tapped
    }

    func getPhotoCount() -> Int {
        return PhotoManager.photos.count
    }

    func getPhoto(index: Int) -> UIImage {
        return PhotoManager.photos[index]
    }

    func setCurrentPhotoIndex(index: Int) {
        PhotoManager.currentPhotoIndex = index
    }

    func addImage(pickedImage: UIImage) {
        // add picked image
        var date = String(Date.timeIntervalSinceReferenceDate)
        var imageID = date.replacingOccurrences(of: ".", with: "-") + ".png"

        let filePath = DocumentsManager.documentsURL.appendingPathComponent("\(imageID)")

        do {
            if let jpgImageData = pickedImage.jpegData(compressionQuality: 1.0) {
                try jpgImageData.write(to: filePath)
                DocumentsManager.filePaths.append("\(imageID)")
            }
        } catch {
            print("couldn't write image")
        }

        savePhoto()
    }

    func savePhoto() {
        // save photo path to core data
        var managedContext = CoreDataManager.shared.managedObjectContext

        let newPhotoSave = Photo(context: managedContext)
        newPhotoSave.path = DocumentsManager.filePaths.last
        PhotoManager.loadedPhotos.append(newPhotoSave)

        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }

        if TasksManager.photo == false {
            TasksManager.photo = true
            DataFunctions.saveTasks(updatingActivity: false, removeAll: false)
        }
    }

    func deletePhoto(indexes: [IndexPath]?) -> Bool? {
        // delete selected photos
        guard let indexList = indexes else { return nil }

        let orderedList = indexList.sorted()

        for i in orderedList {
            var count = 0

            let imageID = DocumentsManager.filePaths[i.row]
            let imagePath = DocumentsManager.documentsURL.appendingPathComponent(imageID)

            if DocumentsManager.fileManager.fileExists(atPath: imagePath.path) {
                do {
                    try DocumentsManager.fileManager.removeItem(at: imagePath)
                    print("image deleted")
                } catch let error {
                    print("failed to delete with error \(error)")
                }
            }

            DocumentsManager.filePaths.remove(at: i.row)
            PhotoManager.photos.remove(at: i.row)

            var managedContext = CoreDataManager.shared.managedObjectContext
            managedContext.delete(PhotoManager.loadedPhotos[i.row])

            do {
                try managedContext.save()
                print("delete successful")
            } catch {
                print("Failed to save")
            }

            count += 1
        }

        return true
    }
}
