//
//  SharedModels.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 10.07.24.
//

import Foundation

import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
}
