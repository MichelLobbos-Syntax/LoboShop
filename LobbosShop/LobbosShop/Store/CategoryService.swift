//
//  CategoryService.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import Foundation

class CategoryService {
    func fetchCategories() async throws -> [Product.ProductCategory] {
        let urlString = "https://api.escuelajs.co/api/v1/categories"
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
            let categories = try JSONDecoder().decode([Product.ProductCategory].self, from: data)
            print("Kategorien geladen: \(categories)")
            return categories
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
