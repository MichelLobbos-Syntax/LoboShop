//
//  HomeViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var categories = [Product.ProductCategory]()
    @Published var searchText = ""  
    @Published var selectedCategoryId: Int?

    private var productService = ProductService()
    private var categoryService = CategoryService()

    init() {
        loadProducts()
        loadCategories()
    }

    func loadProducts() {
        Task {
            do {
                let loadedProducts = try await productService.fetchProducts()
                DispatchQueue.main.async {
                    self.products = loadedProducts
                }
            } catch {
                print("Error loading products: \(error)")
            }
        }
    }

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

    func filteredProducts() -> [Product] {
        return products.filter { product in
            (self.selectedCategoryId == nil || product.category.id == self.selectedCategoryId) &&
            (self.searchText.isEmpty || product.title.localizedCaseInsensitiveContains(self.searchText))
        }
    }
}
