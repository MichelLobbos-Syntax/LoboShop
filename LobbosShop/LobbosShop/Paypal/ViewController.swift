////
////  ViewController.swift
////  LobbosShop
////
////  Created by Michel Lobbos on 20.07.24.
////
//
//import UIKit
//import BraintreeCore
//import BraintreePayPal
//
//class ViewController: UIViewController {
//    var braintreeClient: BTAPIClient?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Ersetzen Sie "YOUR_CLIENT_TOKEN" durch Ihren tatsächlichen Client-Token
//        braintreeClient = BTAPIClient(authorization: "YOUR_CLIENT_TOKEN")
//        
//        let payButton = UIButton(type: .system)
//        payButton.setTitle("Pay with PayPal", for: .normal)
//        payButton.addTarget(self, action: #selector(tappedMyPayButton), for: .touchUpInside)
//        payButton.center = view.center
//        view.addSubview(payButton)
//    }
//
//    @objc func tappedMyPayButton() {
//        startPayPalCheckout()
//    }
//
//    func startPayPalCheckout() {
//        guard let braintreeClient = braintreeClient else { return }
//        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
//        let request = BTPayPalCheckoutRequest(amount: "10.00")
//        request.currencyCode = "USD"
//        
//        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
//            if let error = error {
//                print("ERROR: \(error.localizedDescription)")
//            } else if let tokenizedPayPalAccount = tokenizedPayPalAccount {
//                print("Payment method nonce: \(tokenizedPayPalAccount.nonce)")
//                // Verarbeiten Sie hier die Zahlung
//            }
//        }
//    }
//}
