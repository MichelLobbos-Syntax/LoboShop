//
//  OrderModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import Foundation

struct OrderModel: Identifiable {
    let id: UUID
    let date: Date
    let items: [FireCartItem]
    let totalPrice: Double
    let customerName: String
    let email: String
    let address: String
    let city: String
    let postalCode: String
    let paymentMethod: String
    
    // Helper method to calculate total price
    static func calculateTotalPrice(for items: [CartItem]) -> Double {
        items.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
    }
}
