//
// ApiService.swift
// LobbosShop
// Erstellt von Michel Lobbos am 09.07.24.

import Foundation

class ApiService {
    static let shared = ApiService()
    
    // Produkte aus der API abrufen
    func fetchProducts() async throws -> [Product] {
        let urlString = "https://fakestoreapi.com/products"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            // JSON-Daten in ein Array von Product-Objekten decodieren
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw NetworkError.decodingError
        }
    }
}




enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
    case invalidParameter
}
