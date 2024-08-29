//
//  CategoryViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import Foundation


class CategoryViewModel: ObservableObject {
    @Published var categories = [Product.ProductCategory]()
    private var categoryService = CategoryService()

    func loadCategories() {
        Task {
            do {
                let loadedCategories = try await categoryService.fetchCategories()
                DispatchQueue.main.async {
                    self.categories = loadedCategories
                }
            } catch {
                print("Error loading categories: \(error)")
            }
        }
    }
}
