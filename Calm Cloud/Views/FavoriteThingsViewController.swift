//
//  FavoritesViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import CoreData

class FavoriteThingsViewController: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var nav: UINavigationItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Variables
    
    var imagePicker = UIImagePickerController()
    var tappedImage: UIImage?
    var editingPhotos = false
    var finishedDeleting = false
    var leftItem: [UIBarButtonItem] = []
    var leftEditItem: [UIBarButtonItem] = []
    var rightItem: [UIBarButtonItem] = []
    var rightEditItem: [UIBarButtonItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
       
        imagePicker.delegate = self
        
        leftItem = [editButton]
        rightItem = [addButton]
        leftEditItem = [doneButton]
        rightEditItem = [trashButton]
        
        nav.leftBarButtonItems = leftItem
        nav.rightBarButtonItems = rightItem
    }
    
    // MARK: Custom functions
    
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
            showAlert(title: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
    
    func deletePhoto(indexes: [IndexPath]?) {
        // delete selected photos
        guard let indexList = indexes else { return }
      
        let orderedList = indexList.sorted()
      
        for i in orderedList {
            print(i.row)
            var count = 0
            print("row")
            print(i.row-count)
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
            print(i.row-count)
            managedContext.delete(PhotoManager.loadedPhotos[i.row])
            
            do {
                try managedContext.save()
                print("delete successful")
            } catch {
                print("Failed to save")
            }
            
            count += 1
        }
        
        finishedDeleting = true
        collectionView.reloadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPhoto" {
            let destinationViewController = segue.destination as? PhotoViewController
            destinationViewController?.image = tappedImage
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editPhotos(_ sender: UIBarButtonItem) {
        editingPhotos = true
        nav.leftBarButtonItems = leftEditItem
        nav.rightBarButtonItems = rightEditItem
       
        collectionView.reloadData()
    }
    
    @IBAction func deletePhotos(_ sender: UIBarButtonItem) {
        deletePhoto(indexes: collectionView.indexPathsForSelectedItems)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        nav.leftBarButtonItems = leftItem
        nav.rightBarButtonItems = rightItem
        editingPhotos = false
        finishedDeleting = true
        collectionView.reloadData()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FavoriteThingsViewController {
    // image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("called")
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            PhotoManager.photos.append(pickedImage)
            collectionView.reloadData()
            print("have image")
            print(PhotoManager.photos)
            addImage(pickedImage: pickedImage)
        } else {
            print("no image")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
