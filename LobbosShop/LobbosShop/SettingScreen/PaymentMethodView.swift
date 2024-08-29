//
//  PaymentMethodView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct PaymentMethodView: View {
    @Binding var profile: Profile
    @State private var selectedPaymentMethod: String = ""
    @State private var email: String = ""
    @State private var iban: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Selected Payment Method")) {
                Text(selectedPaymentMethod.isEmpty ? "No payment method selected" : selectedPaymentMethod)
            }
            
            Section(header: Text("Credit Card")) {
                Button(action: {
                    selectedPaymentMethod = "Credit Card"
                    profile.selectedPaymentMethod = selectedPaymentMethod
                }) {
                    HStack {
                        Text("Credit Card")
                        Spacer()
                        if selectedPaymentMethod == "Credit Card" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            Section(header: Text("PayPal")) {
                VStack {
                    Button(action: {
                        selectedPaymentMethod = "PayPal"
                        profile.selectedPaymentMethod = selectedPaymentMethod
                    }) {
                        HStack {
                            Text("PayPal")
                            Spacer()
                            if selectedPaymentMethod == "PayPal" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    if selectedPaymentMethod == "PayPal" {
                        TextField("Enter PayPal Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
            }
            
            Section(header: Text("Klarna")) {
                VStack {
                    Button(action: {
                        selectedPaymentMethod = "Klarna"
                        profile.selectedPaymentMethod = selectedPaymentMethod
                    }) {
                        HStack {
                            Text("Klarna")
                            Spacer()
                            if selectedPaymentMethod == "Klarna" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    if selectedPaymentMethod == "Klarna" {
                        TextField("Enter Klarna Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
            }
            
            Section(header: Text("Invoice")) {
                // No additional input needed for invoice
                Button(action: {
                    selectedPaymentMethod = "Invoice"
                    profile.selectedPaymentMethod = selectedPaymentMethod
                }) {
                    HStack {
                        Text("Invoice")
                        Spacer()
                        if selectedPaymentMethod == "Invoice" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            Section(header: Text("Bank Transfer")) {
                VStack {
                    Button(action: {
                        selectedPaymentMethod = "Bank Transfer"
                        profile.selectedPaymentMethod = selectedPaymentMethod
                    }) {
                        HStack {
                            Text("Bank Transfer")
                            Spacer()
                            if selectedPaymentMethod == "Bank Transfer" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    if selectedPaymentMethod == "Bank Transfer" {
                        TextField("Enter IBAN", text: $iban)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .keyboardType(.alphabet)
                            .autocapitalization(.none)
                    }
                }
            }
        }
        .navigationTitle("Payment Method")
        .onAppear {
            selectedPaymentMethod = profile.selectedPaymentMethod
        }
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        let profile = Profile(
            name: "John",
            lastName: "Doe",
            email: "john.doe@example.com",
            birthDate: Date(),
            address: "123 Main Street",
            city: "Somewhere",
            postalCode: "12345",
            selectedPaymentMethod: "Credit Card",
            profileImageName: "profileImage"
        )
        
        return NavigationStack {
            PaymentMethodView(profile: .constant(profile))
        }
    }
}
