//
//  FireCartItem.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 12.07.24.
//

import Foundation

struct FireCartItem: Codable, Identifiable {
    var id: String
    var userId: String
    var productId: Int
    var productName: String
    var productPrice: Double
    var quantity: Int
    var color: String
    var size: String
    var productImage: String
}
