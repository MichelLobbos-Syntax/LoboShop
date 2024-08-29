//
//  FireUser.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import Foundation

struct FireUser: Codable, Identifiable, Equatable {
    let id: String
    let email: String
    var nickname: String
    var firstName: String?
    var lastName: String?
    let registeredAt: Date
    var address: String?
    var city: String?
    var postalCode: String?
    var selectedPaymentMethod: String?
}
