//
//  Model.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let category: ProductCategory
    let images: [String]

    struct ProductCategory: Codable, Identifiable {
        let id: Int
        let name: String
        let image: String
    }
}
