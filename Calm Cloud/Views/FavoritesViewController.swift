//
//  FavoritesViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Variables
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
       
        imagePicker.delegate = self
        
    }
    
    // MARK: Custom functions
    
    func addImage(pickedImage: UIImage) {
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: IBActions
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FavoritesViewController {
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
