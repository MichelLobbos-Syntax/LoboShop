//
//  CartView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @EnvironmentObject var orderViewModel: OrdersViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var selectedTab: Int
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Text("Cart")
                    .font(.largeTitle)
                Divider()
                if cartViewModel.cartItems.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "cart")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundStyle(.black.opacity(0.7))
                            .padding(.trailing, 13)
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Button("Continue Shopping"){
                            selectedTab = 0
                        }
                        .padding()
                        .background(Color.customBackgroundColor3)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(cartViewModel.cartItems) { item in
                            VStack {
                                HStack {
                                    AsyncImage(url: URL(string: item.productImage)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(10)
                                        case .failure:
                                            Image(systemName: "exclamationmark.triangle")
                                                .foregroundColor(.red)
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(10)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.productName)
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("Preis: \(item.productPrice, specifier: "%.2f") €")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                        Text("Farbe: \(item.color)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                        Text("Größe: \(item.size)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            if item.quantity > 1 {
                                                cartViewModel.updateQuantity(productId: item.productId, quantity: item.quantity - 1, color: item.color, size: item.size)
                                            }
                                        }) {
                                            Image(systemName: "minus.circle")
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Text("\(item.quantity)")
                                            .font(.headline)
                                            .padding(.horizontal)
                                        
                                        Button(action: {
                                            cartViewModel.updateQuantity(productId: item.productId, quantity: item.quantity + 1, color: item.color, size: item.size)
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.vertical, 8)
                                .fixedSize(horizontal: false, vertical: true)
                                
                                Divider()
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let item = cartViewModel.cartItems[index]
                                cartViewModel.removeFromCart(productId: item.productId, color: item.color, size: item.size)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .frame(maxHeight: .infinity)
                    
                    HStack {
                        Text("""
                         Gesamt:
                         \(cartViewModel.totalCost(), specifier: "%.2f") €
                         """)
                        .font(.headline)
                        .padding()
                        Spacer()
                        Button("Bestellen") {
                            showingSheet.toggle()
                        }
                        .padding()
                        .background(Color.customBackgroundColor3)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingSheet) {
                DeliveryView(cartViewModel: cartViewModel, selectedTab: $selectedTab, showingSheet: $showingSheet)
                    .environmentObject(orderViewModel)
                    .environmentObject(userViewModel)
            }
        }
        .scrollContentBackground(.hidden)
    }
}
