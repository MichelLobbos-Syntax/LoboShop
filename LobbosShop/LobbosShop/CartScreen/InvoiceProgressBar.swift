//
//  InvoiceProgressBar.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 24.08.24.
//

import SwiftUI

struct InvoiceProgressBar: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            VStack {
                ProgressView("Generating your invoice...")
                    .foregroundStyle(.white)
                    .bold()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .padding()
                
                Text("Please wait while we prepare your invoice")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        }
    }
}
