//
//  OrdersView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var ordersViewModel: OrdersViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                Text("Orders")
                    .font(.largeTitle)
                Divider()
                Spacer()
                if ordersViewModel.orders.isEmpty{
                    Image("folder1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundStyle(.black.opacity(0.7))
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
                else{
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(ordersViewModel.orders) { order in
                                OrderRowView(order: order)
                                    .environmentObject(ordersViewModel)
                            }
                        }
                        .padding()
                    }
                    
                    
                }
                
            }
        }
    }
}
