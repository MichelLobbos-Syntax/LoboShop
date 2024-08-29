//
//  SwiftUIView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct WishListView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            GradientBackgroundView()
            
            VStack {
                if favoritesViewModel.favoriteProducts.isEmpty {
                    Text("Wish-List is Empty.")
                        .font(.title)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(favoritesViewModel.favoriteProducts.indices, id: \.self) { index in
                            
                            HStack {
                                AsyncImage(url: URL(string: favoritesViewModel.favoriteProducts[index].image)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle")
                                            .foregroundColor(.red)
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: 50, height: 50)
                                
                                Text(favoritesViewModel.favoriteProducts[index].title)
                                    .font(.headline)
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .frame(height: 60)
                            
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Wish-List")
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Settings")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let product = favoritesViewModel.favoriteProducts[index]
            favoritesViewModel.removeFromFavorites(product)
        }
    }
}

struct FavoritesListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WishListView()
                .environmentObject(FavoritesViewModel())
        }
    }
}
