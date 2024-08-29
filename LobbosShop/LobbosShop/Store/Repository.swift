//
//  Repository.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import Foundation


class ProductService {
    func fetchProducts() async throws -> [Product] {
        
        let urlString = "https://api.escuelajs.co/api/v1/products"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw NetworkError.noData
        }
        
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            let productsWithImages = products.filter { !$0.images.isEmpty }  
            print("Produkte geladen: \(productsWithImages)")
            return productsWithImages
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
