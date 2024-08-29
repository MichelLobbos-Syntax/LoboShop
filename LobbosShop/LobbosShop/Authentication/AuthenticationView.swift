//
//  AuthenticationView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @State private var identifier: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var nickname: String = ""
    @State private var isRegistering: Bool = true
    @State private var errorMessage: String?
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack{
            Spacer()
            Image("LogoLoboShop")
                .resizable()
                .scaledToFill()
                .frame(width:  400)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
                
                if isRegistering {
                    TextField("Nickname", text: $nickname)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                }
                
                TextField(isRegistering ? "Email" : "Email or Nickname", text: $identifier)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none) // No automatic capitalization
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                if isRegistering {
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .transition(.opacity)
                }
                
                Button(action: {
                    withAnimation {
                        if isRegistering {
                            guard password == confirmPassword else {
                                errorMessage = "Passwords do not match"
                                return
                            }
                            userViewModel.signIn(email: identifier, password: password, nickname: nickname)
                        } else {
                            userViewModel.login(identifier: identifier, password: password)
                        }
                    }
                }) {
                    Text(isRegistering ? "Register" : "Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customBackgroundColor1)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                
                Button(action: {
                    withAnimation {
                        isRegistering.toggle()
                        errorMessage = nil
                    }
                }) {
                    Text(isRegistering ? "Already registered? Login" : "Not registered yet? Register")
                        .foregroundColor(.customBackgroundColor1)
                }
                
                Spacer()
            }
            
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(UserViewModel())
    }
}

extension Color {
    static let customBackgroundColor1 = Color(red: 110/255, green: 139/255, blue: 252/255)
    static let customBackgroundColor2 = Color(red: 131/255, green: 238/255, blue: 252/255)
    static let customBackgroundColor3 = Color(red: 116/255, green: 165/255, blue: 252/255)
}
