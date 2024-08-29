//
//  ProductDetailView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Bilder-Karussell
                TabView {
                    ForEach(product.images, id: \.self) { imageUrl in
                        if let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .frame(maxWidth: .infinity, maxHeight: 300)
                                case .failure(_):
                                    Text("Bild konnte nicht geladen werden")
                                        .frame(width: 300, height: 300)
                                case .empty:
                                    ProgressView()
                                        .frame(width: 300, height: 300)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
                .padding(.top, 20)

                // Produkttitel
                Text(product.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Preis des Produkts
                Text("\(product.price) EUR")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                // Beschreibung
                Text(product.description)
                    .font(.body)
                    .padding()

                // Kategorie anzeigen
                HStack {
                    Text("Kategorie:")
                        .fontWeight(.bold)
                    Text(product.category.name)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Produktdetails")
        .navigationBarTitleDisplayMode(.inline)
    }
}
