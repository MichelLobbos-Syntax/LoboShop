//
//  ProfileView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var showSaveOverlay: Bool = false
    
    var body: some View {
        ZStack {  // ZStack ermöglicht das Überlagern von Views
            VStack {
                ScrollView {
                    VStack {
                        Section(header: Text("Profile").font(.largeTitle)) {
                            CustomTextField(placeholder: "Nickname", text: $nickname)
                            CustomTextField(placeholder: "Name", text: $firstName)
                            CustomTextField(placeholder: "LastName", text: $lastName)
                            ReadOnlyTextField(placeholder: "Email", text: $email)
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    userViewModel.saveProfile(nickname: nickname, firstName: firstName, lastName: lastName)
                    showSaveOverlay = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showSaveOverlay = false
                    }
                }) {
                    Text("Save")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customBackgroundColor3)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Spacer()
                Spacer()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .onAppear {
                if let user = userViewModel.user {
                    nickname = user.nickname
                    email = user.email
                    firstName = user.firstName ?? ""
                    lastName = user.lastName ?? ""
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Setting")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            if showSaveOverlay {
                VStack {
                    Text("Profile updated")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .transition(.opacity)
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var isEmpty: Bool {
        text.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundStyle(.white)
            TextField("", text: $text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                )
        }
        .padding(.vertical, 5)
    }
}

struct ReadOnlyTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .font(.subheadline)
                .foregroundStyle(.white)
            TextField("", text: $text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .disabled(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
        }
        .padding(.vertical, 5)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
                .environmentObject(UserViewModel())
        }
    }
}
