//
//  OrderItemView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI
import FirebaseAuth

struct OrderItemView: View {
    let item: FireCartItem
    @State private var rating: Double = 0.0
    @State private var comment: String = ""
    @State private var showRatingView = false
    @EnvironmentObject var ordersViewModel: OrdersViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: item.productImage)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.productName)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("Quantity: \(item.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Price: \(item.productPrice, specifier: "%.2f") €")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 8)
                
                Spacer()
                
                Button(action: {
                    showRatingView.toggle()
                }) {
                    Text("Rate")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            
            if showRatingView {
                VStack {
                    Text("Rate this item")
                        .font(.headline)
                    
                    HStack {
                        ForEach(1..<6) { star in
                            Image(systemName: rating >= Double(star) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    rating = Double(star)
                                }
                        }
                    }
                    .padding(.vertical)
                    
                    TextField("Comment", text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        saveRating()
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .shadow(radius: 5)
            }
        }
    }
    
    func saveRating() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newRating = FireRating(id: UUID().uuidString, userId: userId, productId: item.productId, rating: rating, comment: comment, date: Date())
        ordersViewModel.saveRating(newRating)
        showRatingView = false
    }
}
