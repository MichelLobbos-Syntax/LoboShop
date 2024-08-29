//
//  ProductDetailView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 18.07.24.
//



import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var ordersViewModel: OrdersViewModel
    
    @State private var showOrderSheet: Bool = false
    @State private var orderQuantity: Int = 1
    @State private var selectedColor: String = "Red"
    @State private var selectedSize: String = "M"
    
    let colors = ["Red", "Green", "Blue"]
    let sizes = ["S", "M", "L"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    AsyncImage(url: URL(string: product.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 75)
                    .padding(.vertical, 25)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if favoritesViewModel.isFavorite(product) {
                                        favoritesViewModel.removeFromFavorites(product)
                                    } else {
                                        favoritesViewModel.addToFavorites(product)
                                    }
                                }
                            }) {
                                Text(favoritesViewModel.isFavorite(product) ? "Added to Wishlist" : "Add to Wishlist")
                                    .foregroundStyle(.white)
                                    .padding()
                                
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(favoritesViewModel.isFavorite(product) ? Color.yellow : Color.gray.opacity(0.5), lineWidth: 2)
                                    )
                                    .scaleEffect(favoritesViewModel.isFavorite(product) ? 0.9 : 0.8)
                                    .animation(.spring(), value: favoritesViewModel.isFavorite(product))
                            }
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Anzeige des durchschnittlichen Ratings
                    HStack {
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= Int(ordersViewModel.averageRating(for: product.id)) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }
                        .padding(.leading, 5)
                        Text(String(format: "%.1f", ordersViewModel.averageRating(for: product.id)))
                            .foregroundColor(.primary)
                    }
                    HStack {
                        Text(product.title)
                            .font(.title2)
                            .padding()
                        Spacer()
                        Button(action: {
                            showOrderSheet = true
                        }) {
                            Image(systemName: "cart.badge.plus")
                                .resizable()
                                .frame(width: 40, height: 35)
                        }
                        .frame(width: 50, height: 50)
                        .shadow(radius: 5)
                    }
                    HStack {
                        Text("Price:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(product.price, specifier: "%.2f") €")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 5)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description:")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 10)
                    
                    Divider()
                    
                    ReviewsView(product: product)
                    
                    Divider()
                }
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding()
            }
        }
        .sheet(isPresented: $showOrderSheet) {
            VStack(spacing: 20) {
                Spacer()
                //                Spacer()
                //                Text("Order")
                //                    .font(.largeTitle)
                //                    .fontWeight(.bold)
                
                Picker("Color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(color).tag(color)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Size", selection: $selectedSize) {
                    ForEach(sizes, id: \.self) { size in
                        Text(size).tag(size)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Spacer()
                    Button(action: {
                        if orderQuantity > 1 {
                            orderQuantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("\(orderQuantity)")
                        .font(.title)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        orderQuantity += 1
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding()
                
                Button("Add to cart") {
                    cartViewModel.addToCart(product, quantity: orderQuantity, color: selectedColor, size: selectedSize)
                    showOrderSheet = false
                }
                .padding()
                .background(Color.blue.opacity(0.7))
                .foregroundStyle(.white)
                .cornerRadius(10)
                Spacer()
            }
            .presentationDetents([.fraction(0.4)])
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(id: 1, title: "Sample Product", price: 29.99, description: "This is a sample product description.", category: "electronics", image: "https://via.placeholder.com/150"))
            .environmentObject(CartViewModel())
            .environmentObject(FavoritesViewModel())
            .environmentObject(OrdersViewModel(userViewModel: UserViewModel()))
    }
}
