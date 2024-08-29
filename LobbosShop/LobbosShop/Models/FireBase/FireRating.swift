//
//  FireRating.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 13.07.24.
//

// FireRating.swift
import Foundation

struct FireRating: Codable, Identifiable {
    var id: String
    var userId: String
    var productId: Int
    var rating: Double
    var comment: String?
    var date: Date
}
