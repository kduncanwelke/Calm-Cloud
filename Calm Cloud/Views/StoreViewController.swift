//
//  StoreViewController.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 6/26/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var purchaseContainer: UIView!
    @IBOutlet weak var totalCoins: UILabel!
    @IBOutlet weak var paidImage: UIImageView!
    @IBOutlet weak var coin: UIImageView!
    
    // MARK: Variables
    
    var request: SKProductsRequest!
    var products = [SKProduct]()
    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissWithPurchase), name: NSNotification.Name(rawValue: "dismissWithPurchase"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPurchase), name: NSNotification.Name(rawValue: "dismissPurchase"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        paidImage.alpha = 0.0
        purchaseContainer.isHidden = true
        totalCoins.text = "\(MoneyManager.total)"
        getProducts()
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
        collectionView.reloadData()
    }
    
    // MARK: Custom functions
    
    @objc func dismissPurchase() {
        purchaseContainer.isHidden = true
    }
    
    @objc func dismissWithPurchase() {
        purchaseContainer.isHidden = true
        totalCoins.text = "\(MoneyManager.total)"
        
        view.bringSubviewToFront(paidImage)
        paidImage.animateFadeInSlow()
    }
    
    @objc func refresh() {
        totalCoins.text = "\(MoneyManager.total)"
        totalCoins.animateBounce()
        coin.animateBounce()
    }
    
    @objc func networkRestored() {
        if products.isEmpty {
            getProducts()
        }
        
        if Receipt.isReceiptPresent() {
            validateReceipt()
            print("validate on load")
        } else {
            refreshReceipt()
            print("refresh on load")
        }
    }
    
    func refreshReceipt() {
        print("Requesting refresh of receipt.")
        let refreshRequest = SKReceiptRefreshRequest()
        refreshRequest.delegate = self
        refreshRequest.start()
    }
    
    func validateReceipt() {
        receipt = Receipt()
        if let receiptStatus = receipt?.status {
            guard receiptStatus == .validationSuccess else {
                print(receiptStatus)
                return
            }
        }
    }
   
    // MARK: Store functions
    
    func getProducts() {
        var isAuthorizedForPayments: Bool {
            return SKPaymentQueue.canMakePayments()
        }
        
        if isAuthorizedForPayments {
            validate(productIdentifiers: [Products.tenCoins, Products.twentyCoins, Products.thirtyCoins, Products.fortyCoins, Products.fiftyCoins, Products.seventyCoins, Products.oneHundredCoins, Products.twoHundredCoins, Products.twoHundredFiftyCoins, Products.fiveHundredCoins])
        }
    }
    
    func validate(productIdentifiers: [String]) {
        let productIdentifiers = Set(productIdentifiers)
        
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
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
        collectionView.reloadData()
        
        if products.isEmpty == false {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        // reset buying items
        PlantManager.buying = nil
        ItemManager.buying = nil
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension StoreViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count == Products.productQuantities.count {
            products = response.products
            for product in products {
                print(product.localizedTitle)
                print(product.price)
                print(product.priceLocale)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            // handle invalid case
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
    }
    
    func requestDidFinish(_ request: SKRequest) {
        if Receipt.isReceiptPresent() {
            validateReceipt()
        }
    }
}
