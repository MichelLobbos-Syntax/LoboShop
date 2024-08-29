//
//  FireOrder.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 12.07.24.
//

import Foundation

struct FireOrder: Codable, Identifiable {
    var id: String
    var date: Date
    var userId: String 
    var items: [FireCartItem]
    var totalPrice: Double
    var customerName: String
    var email: String
    var address: String
    var city: String
    var postalCode: String
    var paymentMethod: String
}
