//
// HomeViewModel.swift
// LobbosShop
// Erstellt von Michel Lobbos am 09.07.24.


import Combine
import SwiftUI


@MainActor
class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    @Published var selectedPrice: Double = Double.infinity
    @Published var sortOption: SortOption = .none
    
    init() {
        Task {
            await fetchProducts()
        }
    }
    
    var filteredProducts: [Product] {
        var filtered = products.filter { product in
            (selectedCategory == nil || product.category == selectedCategory) &&
            (searchText.isEmpty || product.title.lowercased().contains(searchText.lowercased())) &&
            (product.price <= selectedPrice)
        }
        
        switch sortOption {
        case .priceLowToHigh:
            filtered.sort { $0.price < $1.price }
        case .priceHighToLow:
            filtered.sort { $0.price > $1.price }
        case .none:
            break
        }
        
        return filtered
    }
    
    func fetchProducts() async {
        do {
            let products = try await ApiService.shared.fetchProducts()
            self.products = products
        } catch {
            print("Error fetching products: \(error)")
        }
    }
}



enum SortOption: String, CaseIterable, Identifiable {
    case none = "None"
    case priceLowToHigh = "Low to High"
    case priceHighToLow = "High to Low"
    
    var id: String { self.rawValue }
}
