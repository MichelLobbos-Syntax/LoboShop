//
//  TranslationViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 26.07.24.
//



import SwiftUI
import Combine

class TranslationViewModel: ObservableObject {
    @Published var translatedComments: [String: String] = [:]
    @Published var showOriginal: [String: Bool] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let translationService = TranslationService()
    
    func translate(text: String, from sourceLang: String = "auto", to targetLang: String = "en") async {
        do {
            let translationResponse = try await translationService.translate(text: text, from: sourceLang, to: targetLang)
            DispatchQueue.main.async {
                self.translatedComments[text] = translationResponse.trans
                self.showOriginal[text] = false
                print("Original: \(text) | Translated: \(translationResponse.trans)")
            }
        } catch {
            print("Translation API error: \(error.localizedDescription)")
        }
    }
    
    func toggleShowOriginal(for text: String) {
        showOriginal[text]?.toggle()
    }
}
