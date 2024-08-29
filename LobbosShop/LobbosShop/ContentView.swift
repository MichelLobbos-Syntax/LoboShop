//
//  ContentView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 01.07.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var ordersViewModel = OrdersViewModel(userViewModel: UserViewModel())
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State private var selectedTab: Int = 0
    
    init() {
        setupTabBarAppearance()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Store", systemImage: "storefront")
                }
                .tag(0)
                .environmentObject(HomeViewModel())
                .environmentObject(cartViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(ordersViewModel)
            
            CartView(cartViewModel: cartViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .tag(1)
                .environmentObject(cartViewModel)
                .environmentObject(ordersViewModel)
                .badge(cartViewModel.cartItems.count > 0 ? String(cartViewModel.cartItems.count) : nil)
            
            OrdersView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Orders", systemImage: "list.bullet")
                }
                .tag(2)
                .environmentObject(ordersViewModel)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
                .environmentObject(userViewModel)
                .environmentObject(favoritesViewModel)
        }
        .environmentObject(favoritesViewModel)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.customBackgroundColor3)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
