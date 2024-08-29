//
// ProductCardView.swift
// LobbosShop
// Erstellt von Michel Lobbos am 09.07.24.

// ProductCardView.swift

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @EnvironmentObject var ordersViewModel: OrdersViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.gray)
                } else {
                    ProgressView()
                        .frame(height: 150)
                }
            }
            .cornerRadius(10)
            
            Text(product.title)
                .font(.headline)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("\(product.price, specifier: "%.2f") €")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let averageRating = ordersViewModel.averageRating(for: product.id)
                HStack(spacing: 0.01) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= Int(averageRating) ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(width: 180, height: 250)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.customBackgroundColor1, radius: 10, x: 5, y: 5)
        .scaleEffect(0.95)
        .onAppear {
            ordersViewModel.reloadOrders()
        }
    }
}

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProductCardView(product: Product(id: 1, title: "Sample Product", price: 29.99, description: "This is a sample product description.", category: "electronics", image: "https://via.placeholder.com/150"))
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .light)
                .environmentObject(OrdersViewModel(userViewModel: UserViewModel()))
            
            ProductCardView(product: Product(id: 1, title: "Sample Product", price: 29.99, description: "This is a sample product description.", category: "electronics", image: "https://via.placeholder.com/150"))
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
                .environment(\.colorScheme, .dark)
                .environmentObject(OrdersViewModel(userViewModel: UserViewModel())) 
        }
    }
}
