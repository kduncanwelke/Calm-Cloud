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

    private let storeViewModel = StoreViewModel()
    
    var request: SKProductsRequest!
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
        totalCoins.text = storeViewModel.getCoinTotal()
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
        totalCoins.text = storeViewModel.getCoinTotal()
        
        view.bringSubviewToFront(paidImage)
        paidImage.animateFadeInSlow()
    }
    
    @objc func refresh() {
        totalCoins.text = storeViewModel.getCoinTotal()
        totalCoins.animateBounce()
        coin.animateBounce()
    }
    
    @objc func networkRestored() {
        if storeViewModel.areThereProducts() == false {
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

    // MARK: Store functions

    func validate(productIdentifiers: [String]) {
        let productIdentifiers = Set(productIdentifiers)

        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func getProducts() {
        var isAuthorizedForPayments: Bool {
            return SKPaymentQueue.canMakePayments()
        }

        if isAuthorizedForPayments {
            let identifiers = storeViewModel.getProductIdentifiers()

            validate(productIdentifiers: identifiers)
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
        
        if storeViewModel.areThereProducts() {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
        // reset buying items
        storeViewModel.resetItems()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StoreViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count == Products.productQuantities.count {
            storeViewModel.assignProducts(loadedProducts: response.products)

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

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storeViewModel.getItemCount(segment: segmentedControl.selectedSegmentIndex)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storeCell", for: indexPath) as! StoreCollectionViewCell

        cell.nameLabel.text = storeViewModel.getName(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)
        cell.itemImage.image = storeViewModel.getImage(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        let availableWidth = collectionView.frame.width
        cell.backgroundColor = storeViewModel.setCellColor(availableWidth: availableWidth, index: indexPath.row)

        cell.priceLabel.text = storeViewModel.getPrice(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        cell.coinImage.isHidden = storeViewModel.hideCoinImage(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        cell.area.text = storeViewModel.getAreaText(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        cell.numberOwned.text = storeViewModel.getNumberOwned(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        var growth = storeViewModel.showGrowthSpeed(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        if let title = growth.title, let image = growth.image {
            cell.growthSpeed.setTitle(growth.title, for: .normal)
            cell.growthSpeed.setBackgroundImage(image, for: .normal)
            cell.growthSpeed.isHidden = false
        } else {
            cell.growthSpeed.isHidden = true
        }

        cell.purchaseDescription.text = storeViewModel.getDescription(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 || segmentedControl.selectedSegmentIndex == 1  {
            // seedling or item purchase
            storeViewModel.setBuying(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)
            purchaseContainer.isHidden = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadUI"), object: nil)
        } else {
            // in coin shop view, make purchase
            let isAuthorizedForPayments = SKPaymentQueue.canMakePayments()

            if isAuthorizedForPayments && storeViewModel.areThereProducts() {
                if NetworkMonitor.connection {
                    storeViewModel.setBuying(segment: segmentedControl.selectedSegmentIndex, index: indexPath.row)
                    storeViewModel.buy()
                } else {
                    showAlert(title: "Purchases unavailable", message: "Purchases cannot be processed without a network connection - please try again")
                }
            } else {
                showAlert(title: "Payments not authorized", message: "This device is not permitted to process payments")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width
        var maxNumColumns = 3

        if (availableWidth / 3) < 160.0 {
            maxNumColumns = 2
        }

        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)

        return CGSize(width: cellWidth, height: 192.00)
    }
}

