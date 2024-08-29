//
//  Product.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import Foundation


struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
}
