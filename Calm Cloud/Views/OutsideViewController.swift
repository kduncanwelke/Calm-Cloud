//
//  OutsideViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 4/10/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit

class OutsideViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let offset = container.frame.width / 5
        scrollView.contentOffset = CGPoint(x: offset, y: 0)
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
    
    @IBAction func returnPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "returnIndoors"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
