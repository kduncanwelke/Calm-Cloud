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

    private let favesViewModel = FavoritesViewModel()
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
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
        if let result = favesViewModel.deletePhoto(indexes: collectionView.indexPathsForSelectedItems) {
            finishedDeleting = true
            collectionView.reloadData()
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        nav.leftBarButtonItems = leftItem
        nav.rightBarButtonItems = rightItem
        editingPhotos = false
        finishedDeleting = true
        collectionView.reloadData()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
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
            favesViewModel.addImage(pickedImage: pickedImage)
        } else {
            print("no image")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension FavoriteThingsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favesViewModel.getPhotoCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell

        if finishedDeleting && editingPhotos == false {
            cell.checkButton.isHidden = true
        } else if finishedDeleting {
            cell.checkButton.isHidden = false
            cell.checkButton.setImage(UIImage(named: "unchecked"), for: .normal)
            cell.image.alpha = 1.0
        } else if editingPhotos {
            cell.checkButton.isHidden = false
        } else {
            cell.checkButton.isHidden = true
        }

        cell.image.image = favesViewModel.getPhoto(index: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PhotoCollectionViewCell

        if editingPhotos {
            finishedDeleting = false
            if let indexList = collectionView.indexPathsForSelectedItems {
                if indexList.contains(indexPath) {
                    tappedCell.checkButton.setImage(UIImage(named: "correct"), for: .normal)
                    tappedCell.image.alpha = 0.7
                    print("selected")
                }
            }
        } else {
            tappedImage = tappedCell.image.image
            favesViewModel.setCurrentPhotoIndex(index: indexPath.row)
            print(PhotoManager.currentPhotoIndex )
            performSegue(withIdentifier: "viewPhoto", sender: Any?.self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tappedCell = collectionView.cellForItem(at:indexPath) as! PhotoCollectionViewCell

        if editingPhotos {
            tappedCell.checkButton.setImage(UIImage(named: "unchecked"), for: .normal)
            tappedCell.image.alpha = 1.0
            print("not selected")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        let maxNumColumns = 3
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        return CGSize(width: cellWidth, height: cellWidth)
    }
}
