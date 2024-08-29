//
//  CartItem.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    var color: String
    var size: String
    
    
    var price: Double {
            return product.price
        }
}
