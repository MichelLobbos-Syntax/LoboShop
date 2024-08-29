//
//  PayPalPayment.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 24.07.24.
//

import Foundation


// PayPalPayment-Model
struct PayPalPayment: Codable {
    let intent: String
    let payer: Payer
    let transactions: [Transaction]
    let redirect_urls: RedirectUrls
}

// Payer-Model
struct Payer: Codable {
    let payment_method: String
}

// Transaction-Model
struct Transaction: Codable {
    let amount: Amount
    let description: String
}

// Amount-Model
struct Amount: Codable {
    let total: String
    let currency: String
}

// RedirectUrls-Model
struct RedirectUrls: Codable {
    let return_url: String
    let cancel_url: String
}
