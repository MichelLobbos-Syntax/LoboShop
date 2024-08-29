//
//  LobbosShopApp.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 01.07.24.
//

import SwiftUI
import FirebaseCore

@main
struct LobbosShopApp: App {
    @StateObject private var userViewModel = UserViewModel()
    @State private var showSplash = true
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .environmentObject(userViewModel)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showSplash = false
                            }
                        }
                    }
            } else {
                if userViewModel.isUserLoggedIn {
                    ContentView()
                        .environmentObject(userViewModel)
                        .preferredColorScheme(.light)
                } else {
                    AuthenticationView()
                        .environmentObject(userViewModel)
                        .preferredColorScheme(.light)
                }
            }
        }
    }
}
