//
//  FavoritesViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = [] {
        didSet {
            saveFavoriteProducts()
        }
    }
    
    private let db = Firestore.firestore()
    
    init() {
        loadFavoriteProducts()
        fetchFavoritesFromFirestore()
    }
    
    func addToFavorites(_ product: Product) {
        if !favoriteProducts.contains(where: { $0.id == product.id }) {
            favoriteProducts.append(product)
            saveProductToFirestore(product)
        }
    }
    
    func removeFromFavorites(_ product: Product) {
        if let index = favoriteProducts.firstIndex(where: { $0.id == product.id }) {
            favoriteProducts.remove(at: index)
            deleteProductFromFirestore(product)
        }
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
    
    private func saveFavoriteProducts() {
        if let data = try? JSONEncoder().encode(favoriteProducts) {
            UserDefaults(suiteName: "group.LoboShop")?.set(data, forKey: "favoriteProducts")
        }
    }
    
    private func loadFavoriteProducts() {
        if let data = UserDefaults(suiteName: "group.LoboShop")?.data(forKey: "favoriteProducts"),
           let products = try? JSONDecoder().decode([Product].self, from: data) {
            favoriteProducts = products
        }
    }
    
    private func fetchFavoritesFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("favorites").whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching favorites: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            let products = documents.compactMap { document in
                try? document.data(as: Product.self)
            }
            
            DispatchQueue.main.async {
                self.favoriteProducts = products
            }
        }
    }
    
    private func saveProductToFirestore(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "userId": userId,
            "id": product.id,
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "category": product.category,
            "image": product.image
        ]
        
        db.collection("favorites").addDocument(data: data) { error in
            if let error = error {
                print("Error saving product to Firestore: \(error)")
            }
        }
    }
    
    private func deleteProductFromFirestore(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("favorites")
            .whereField("userId", isEqualTo: userId)
            .whereField("id", isEqualTo: product.id)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching favorite product for deletion: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                for document in documents {
                    document.reference.delete { error in
                        if let error = error {
                            print("Error deleting product from Firestore: \(error)")
                        }
                    }
                }
            }
    }
}
