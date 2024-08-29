//
//  AliExpressApi.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 06.07.24.
//

import Foundation

class AliExpressApi {
    func fetchProduct(query: String, sort: String, startPrice: String?, endPrice: String?, category: String?) async throws -> [ResultList] {
        guard !query.isEmpty else {
            throw NetworkError.invalidParameter
        }
        
        var urlString = "https://aliexpress-datahub.p.rapidapi.com/item_search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sort=\(sort)&locale=de_DE&region=DE&currency=EUR"
        
        if let startPrice = startPrice, !startPrice.isEmpty {
            urlString += "&startPrice=\(startPrice)"
        }
        
        if let endPrice = endPrice, !endPrice.isEmpty {
            urlString += "&endPrice=\(endPrice)"
        }
        
        if let category = category, !category.isEmpty {
            urlString += "&category=\(category)"
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("49c814abc1msha0fe8436deb7fd3p1f7d4ejsna0f8d6966749", forHTTPHeaderField: "x-rapidapi-key")
        request.setValue("aliexpress-datahub.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Log the raw JSON response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON response: \(jsonString)")
        }
        
        do {
            let response = try JSONDecoder().decode(ApiResponse.self, from: data)
            return response.result.resultList
        } catch {
            print("Decoding error: \(error)")
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
