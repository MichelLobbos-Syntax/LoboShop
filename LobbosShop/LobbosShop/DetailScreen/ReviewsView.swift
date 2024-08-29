//
//  ReviewsView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 17.07.24.
//

import SwiftUI

struct ReviewsView: View {
    let product: Product
    @EnvironmentObject var orderViewModel: OrdersViewModel
    @StateObject private var translationViewModel = TranslationViewModel()
    
    var body: some View {
        VStack {
            Text("Reviews:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(orderViewModel.ratings.filter { $0.productId == product.id }) { rating in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text(rating.userId)
                            .font(.headline)
                        Spacer()
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= Int(rating.rating) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                    
                    // Check if there's a comment and handle translation
                    if let comment = rating.comment, !comment.isEmpty {
                        if let translatedComment = translationViewModel.translatedComments[comment] {
                            if translationViewModel.showOriginal[comment] == true {
                                Text(comment)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            } else {
                                Text(translatedComment)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            Button(translationViewModel.showOriginal[comment] == true ? "Translate" : "Show Original") {
                                translationViewModel.toggleShowOriginal(for: comment)
                            }
                            .padding(.top, 5)
                        } else {
                            Text(comment)
                                .font(.body)
                                .foregroundColor(.primary)
                            Button("Translate") {
                                Task {
                                    await translationViewModel.translate(text: comment)
                                }
                            }
                            .padding(.top, 5)
                        }
                    } else {
                        // Add an empty Text view to maintain the same height
                        Text("No comment provided.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .opacity(0) // Make it invisible but still take space
                    }
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
            }
        }
        .padding(.top, 10)
        .onAppear {
            print("Reviews for product: \(product.title)")
        }
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView(product: Product(id: 1, title: "Sample Product", price: 29.99, description: "Sample description", category: "Sample category", image: "https://via.placeholder.com/150"))
            .environmentObject(OrdersViewModel(userViewModel: UserViewModel()))
    }
}
