//
//  PhotoViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 3/30/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var imageLeading: NSLayoutConstraint!
    @IBOutlet weak var imageTrailing: NSLayoutConstraint!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: Variables
    
   private let photoViewModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self

        imageView.image = photoViewModel.getPhoto()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateZoom(view.bounds.size)
    }
    
    // MARK: Custom functions
    
    // allow zooming in but limit zooming out to size where image fits on screen
    func updateZoom(_ size: CGSize) {
        let boundsSize = view.bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = 1 + (1 * (imageSize.width / boundsSize.width))
        let yScale = 1 + (1 * (imageSize.height / boundsSize.height))
        
        let maxScale = max(xScale, yScale)
        
        scrollView.maximumZoomScale = maxScale
        scrollView.minimumZoomScale = 1
    }
    
    func centerImage() {
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize = view.bounds.size
        var frameToCenter = scrollView?.frame ?? CGRect.zero
        
        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width)/2
        } else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - (frameToCenter.size.height + buttonView.bounds.height))///2
        } else {
            frameToCenter.origin.y = 0
        }
        
        scrollView?.frame = frameToCenter
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
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        // go to previous
        if photoViewModel.decreasePhotoIndex() {
            imageView.animateImageLeft()
            imageView.image = photoViewModel.getPhoto()
        } else {
            return
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        // go to next
        if photoViewModel.increasePhotoIndex() {
            imageView.animateImageRight()
            imageView.image = photoViewModel.getPhoto()
        } else {
            return
        }
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
