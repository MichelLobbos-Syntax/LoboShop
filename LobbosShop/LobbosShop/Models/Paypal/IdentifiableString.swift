//
//  IdentifiableString.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 24.07.24.
//

import SwiftUI
import FirebaseAuth
import SafariServices

struct IdentifiableString: Identifiable, Equatable {
    let id = UUID()
    let value: String
}

struct IdentifiableStringWrapper: Identifiable, Equatable {
    let id = UUID()
    let value: String
}
