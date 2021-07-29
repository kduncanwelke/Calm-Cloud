//
//  RemoveViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/22/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class RemoveViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var message: UILabel!

    // MARK: Variables

    private let viewModel = OutsideViewModel()
    var remove = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadRemove), name: NSNotification.Name(rawValue: "loadRemove"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadWilted), name: NSNotification.Name(rawValue: "loadWilted"), object: nil)
    }
    
    @objc func loadRemove() {
        viewModel.setName()
        
        message.text = "This plant, a \(viewModel.getName()), will be gone forever once removed. Proceed?"
    }
    
    @objc func loadWilted() {
        viewModel.setName()
        
        message.text = "This plant, a wilted \(viewModel.getName()), will be gone forever once removed. Proceed?"
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
    
    @IBAction func yesTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removePlant"), object: nil)
    }
    
    @IBAction func noTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "closeRemoveMessage"), object: nil)
    }
}
