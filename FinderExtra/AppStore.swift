//
//  AppStore.swift
//  FinderExtra
//
//  Created by Stormacq, Sebastien on 10/09/2020.
//  Copyright © 2020 Stormacq, Sebastien. All rights reserved.
//

import Foundation
import StoreKit

typealias PurchasableProduct      = SKProduct
typealias ProductRequestCallback  = ([PurchasableProduct]) -> Void
typealias PurchaseRequestCallback = (Bool) -> Void

class StoreManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let shared : StoreManager = StoreManager()
    
    /// Keeps a strong reference to the product request.
    fileprivate var productRequest : SKProductsRequest!
    fileprivate var productArray   : [PurchasableProduct] = []
    fileprivate var productRequestCallback  : ProductRequestCallback?
    fileprivate var purchaseRequestCallback : PurchaseRequestCallback?
    
    /// Initialize the store observer.
    private override init() {
        super.init()
    }
    
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // MARK: - Manage registration to the payment queue
    
    func register(action: (Bool) -> Void) {
        SKPaymentQueue.default().add(StoreManager.shared)
        
        self.validateReceipt(action)
    }
    
    func unregister() {
        SKPaymentQueue.default().remove(StoreManager.shared)
    }
    
    // MARK: - Validate App Store Receipt
    
    //
    // check if app has been purchased and the validity of the receipt
    //
    private func validateReceipt(_ action: (Bool) -> Void) {
        
        // Get the receipt if it's available
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                let receiptData   = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                print(receiptString)
                // server side validation of receiptData
                
                // notify the caller
                action(true)
                
            }
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
                action(false)
            }
            
        } else {
            print("app has not been purchased")
            action(false)
        }
    }
    
    // MARK: - Request Product Information
    
    /// Starts the product request with the specified identifiers.
    func doProductRequest(action: @escaping ProductRequestCallback) {
        
        // keep a strong ref to the callback function; it will be called by the delegate
        self.productRequestCallback = action
        
        // identifier is defined in app store connect https://appstoreconnect.apple.com/
        self.startProductRequest(with: ["001"])
        
    }
    
    private func startProductRequest(with identifiers: [String]) {
        
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        
        // Send the request to the App Store.
        print("initiating a product request to the app store")
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count != 0 {
            for product in response.products {
                self.productArray.append(product)
            }
            
            // when displaying the product on the UI, we must trigger a UI refresh here
            
            if let action = self.productRequestCallback {
                action(self.productArray)
            }
        } else {
            print("There are no products.")
        }
    }
    
    
    // MARK: Purchases, Payment Transaction Observer
    
    func buy(product: SKProduct, action: @escaping PurchaseRequestCallback ) {
        
        // keep a strong ref to the callback function; it will be called by the delegate
        self.purchaseRequestCallback = action
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    /// Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
                case SKPaymentTransactionState.purchased:
                    print("Transaction completed successfully.")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    // notify the caller
                    if let action = purchaseRequestCallback {
                        action(true)
                }
                
                case SKPaymentTransactionState.failed:
                    print("Transaction Failed");
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    // notify the caller
                    if let action = purchaseRequestCallback {
                        action(false)
                }
                
                case SKPaymentTransactionState.restored:
                    print("Transaction restored successfully.")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    
                    // notify the caller
                    if let action = purchaseRequestCallback {
                        action(true)
                }
                
                case SKPaymentTransactionState.deferred:
                    print("Transaction deferred")
                case SKPaymentTransactionState.purchasing:
                    print("Transaction purchasing")
                
                default:
                    print(transaction.transactionState.rawValue)
            }
        }
        
    }
    
}
