//
//  SettingsView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @StateObject var ordersViewModel = OrdersViewModel(userViewModel: UserViewModel())
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            NavigationStack {
                VStack {
                    List {
                        Section {
                            NavigationLink(destination: ProfileView()) {
                                HStack {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Profile")
                                }
                            }
                            
                            NavigationLink(destination: AddressView()) {
                                HStack {
                                    Image(systemName: "house")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Delivery Address")
                                }
                            }
                            
                            NavigationLink(destination: WishListView()) {
                                HStack {
                                    Image(systemName: "bag.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Wish-List")
                                }
                            }
                        }
                        
                        Section {
                            NavigationLink(destination: AGBView()) {
                                HStack {
                                    Image(systemName: "doc.text")
                                        .resizable()
                                        .frame(width: 20, height: 24)
                                    Text("Terms and Conditions")
                                }
                            }
                        }
                        
                        Section {
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Logout")
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
                    )
                }
                .navigationTitle("Settings")
                .navigationBarBackButtonHidden(true)
                
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Logout"),
                        message: Text("Are you sure you want to log out?"),
                        primaryButton: .destructive(Text("Logout")) {
                            userViewModel.logOut()
                            //                            closeApp()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    //    private func closeApp() {
    //        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    //            exit(0)
    //        }
    //    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserViewModel())
            .environmentObject(FavoritesViewModel())
    }
}
