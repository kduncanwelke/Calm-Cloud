//
//  StoreObserver.swift
//  Calm Cloud
//
//  Created by Kate Duncan-Welke on 7/1/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    static let iapObserver = StoreObserver()
    var restored: [String] = []
    var purchased: [String] = []
    static var isComplete = false
    
    override init() {
        super.init()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("updating transactions")
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                break
            case .deferred:
                print("deferred")
            // The purchase was successful.
            case .purchased:
                complete(transaction: transaction)
                print("purchase succeeded")
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: ""), object: nil)
            // The transaction failed.
            case .failed:
                fail(transaction: transaction)
                print("failed")
            // There are restored products.
            case .restored:
                if !transaction.downloads.isEmpty {
                    queue.start(transaction.downloads)
                }
                print("restored")
            default:
                break
            }
        }
    }
    
    func buy(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
