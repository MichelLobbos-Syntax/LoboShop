//
//  FavoritesViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 10.07.24.
//

import Foundation
import SwiftUI

struct WidgetProduct: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let category: String
    let image: String
}

class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [WidgetProduct] = [] {
        didSet {
            saveFavoriteProducts()
        }
    }

    init() {
        loadFavoriteProducts()
    }

    func addToFavorites(_ product: WidgetProduct) {
        if !favoriteProducts.contains(where: { $0.id == product.id }) {
            favoriteProducts.append(product)
        }
    }

    func removeFromFavorites(_ product: WidgetProduct) {
        if let index = favoriteProducts.firstIndex(where: { $0.id == product.id }) {
            favoriteProducts.remove(at: index)
        }
    }

    func isFavorite(_ product: WidgetProduct) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }

    private func saveFavoriteProducts() {
        if let data = try? JSONEncoder().encode(favoriteProducts) {
            UserDefaults(suiteName: "group.com.yourappgroup")?.set(data, forKey: "favoriteProducts")
        }
    }

    private func loadFavoriteProducts() {
        if let data = UserDefaults(suiteName: "group.com.yourappgroup")?.data(forKey: "favoriteProducts"),
           let products = try? JSONDecoder().decode([WidgetProduct].self, from: data) {
            favoriteProducts = products
        }
    }
}
