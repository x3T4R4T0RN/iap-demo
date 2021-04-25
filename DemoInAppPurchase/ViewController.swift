//
//  ViewController.swift
//  DemoInAppPurchase
//
//  Created by taratorn deachboon on 26/4/2564 BE.
//

import UIKit
import StoreKit
class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    var product: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProduct(productIds: ["com.DemoInAppPurchase.book.0000001"])
    }
    
    @IBAction func onPressedPurchase(_ sender: Any) {
        if let product = self.product {
            makePayment(product: product)
        }
    }
    
    
    /// Fetch product
    func fetchProduct(productIds: Set<String>) {
        let request = SKProductsRequest(productIdentifiers: productIds)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            self.product = product
        }
    }
    
    
    /// Make Payment
    func makePayment(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            
            switch transaction.transactionState {
            case .purchasing:
                print("transaction is on process purchasing")
            case .purchased:
                /// Update to server
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                /// Update to server
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
    
}

