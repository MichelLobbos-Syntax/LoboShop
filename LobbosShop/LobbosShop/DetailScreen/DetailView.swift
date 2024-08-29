//
//  DetailView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//



import SwiftUI

struct DetailView: View {
    let products: [Product]
    @State var selectedIndex: Int
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject var orderViewModel: OrdersViewModel
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            TabView(selection: $selectedIndex) {
                ForEach(products.indices, id: \.self) { index in
                    ProductDetailView(product: products[index])
                        .tag(index)
                }
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text(products[selectedIndex].title)
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .environmentObject(OrdersViewModel(userViewModel: UserViewModel()))
        .onAppear {
            orderViewModel.fetchRatingsForProduct(productId: products[selectedIndex].id)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(products: [Product(id: 1, title: "Sample Product 1", price: 29.99, description: "This is a sample product description.", category: "electronics", image: "https://via.placeholder.com/150"),
                              Product(id: 2, title: "Sample Product 2", price: 49.99, description: "This is another sample product description.", category: "jewelery", image: "https://via.placeholder.com/150")],
                   selectedIndex: 0)
        .environmentObject(CartViewModel())
        .environmentObject(FavoritesViewModel())
        
    }
}
