//
//  StoreViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
