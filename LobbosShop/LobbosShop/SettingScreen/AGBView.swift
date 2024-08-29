//
//  AGBView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 06.08.24.
//



import SwiftUI

struct AGBView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            GradientBackgroundView()
            VStack {
                Text("Terms and Conditions")
                    .font(.largeTitle)
                
                Divider()
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("'Last updated: [28.08.2024]'")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        
                        Divider()
                        
                        Text("1. Introduction")
                            .font(.title2)
                            .bold()
                        Text("""
                Welcome to LobbosShop. These terms and conditions outline the rules and regulations for the use of our app. By accessing this app, we assume you accept these terms and conditions. Do not continue to use LobbosShop if you do not agree to all of the terms and conditions stated on this page.
                """)
                        
                        Text("2. Privacy Policy")
                            .font(.title2)
                            .bold()
                        Text("""
                We are committed to protecting your privacy. Our privacy policy, which sets out how we will use your information, can be found at [link to privacy policy]. By using this app, you consent to the processing described therein and warrant that all data provided by you is accurate.
                """)
                        
                        Text("3. License")
                            .font(.title2)
                            .bold()
                        Text("""
                Unless otherwise stated, LobbosShop and/or its licensors own the intellectual property rights for all material on LobbosShop. All intellectual property rights are reserved. You may access this from LobbosShop for your own personal use subjected to restrictions set in these terms and conditions.
                """)
                        
                        Text("4. User Accounts")
                            .font(.title2)
                            .bold()
                        Text("""
                If you create an account in the app, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security.
                """)
                        
                        Text("5. Limitation of Liability")
                            .font(.title2)
                            .bold()
                        Text("""
                In no event shall LobbosShop, nor any of its officers, directors, and employees, be liable to you for anything arising out of or in any way connected with your use of this app, whether such liability is under contract, tort or otherwise, and LobbosShop, including its officers, directors, and employees shall not be liable for any indirect, consequential, or special liability arising out of or in any way related to your use of this app.
                """)
                        
                        Text("6. Changes to Terms")
                            .font(.title2)
                            .bold()
                        Text("""
                We reserve the right, at our sole discretion, to modify or replace these terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.
                """)
                        
                        Text("Contact Us")
                            .font(.title2)
                            .bold()
                        Text("""
                If you have any questions about these Terms, please contact us at https://michellobbos.netlify.app.
                """)
                    }
                    .padding()
                }
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
                            .foregroundStyle(.white)
                        Text("Settings")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

struct AGBView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AGBView()
        }
    }
}
