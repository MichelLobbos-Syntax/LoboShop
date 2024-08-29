//
//  TranslationService.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 26.07.24.
//

import Foundation

class TranslationService {
    let apiKey = GoogleTranslateKey.key.rawValue
    let apiHost = "google-translate113.p.rapidapi.com"
    
    func translate(text: String, from sourceLang: String = "auto", to targetLang: String = "en") async throws -> TranslationResponse {
        let urlString = "https://google-translate113.p.rapidapi.com/api/v1/translator/text"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let headers = [
            "x-rapidapi-key": apiKey,
            "x-rapidapi-host": apiHost,
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "from": sourceLang,
            "to": targetLang,
            "text": text
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP error: \(response)")
            throw URLError(.badServerResponse)
        }
        
        let translationResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
        return translationResponse
    }
}


