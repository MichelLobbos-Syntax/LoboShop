//
//  HomeView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var showSearchBar = false
    @State private var showFilter = false
    @State private var searchText = ""

    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if showSearchBar {
                    searchBar
                }

                CategoryView(selectedCategoryId: $viewModel.selectedCategoryId, viewModel: viewModel)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredProducts(), id: \.id) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductRow(product: product)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 2, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    searchButton
                    filterButton
                }
            }
            .navigationTitle("Products")
            .onAppear {
                viewModel.loadProducts()
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    private var searchBar: some View {
        HStack {
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                viewModel.searchText = searchText
                viewModel.loadProducts()
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }

    private var searchButton: some View {
        Button(action: {
            withAnimation {
                showSearchBar.toggle()
            }
        }) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.blue)
        }
    }

    private var filterButton: some View {
        Button(action: {
            withAnimation {
                showFilter.toggle()
            }
        }) {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color.blue)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
