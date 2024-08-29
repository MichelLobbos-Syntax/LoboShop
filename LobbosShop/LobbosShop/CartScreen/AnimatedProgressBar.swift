//
//  AnimatedProgressBar.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 25.07.24.
//

import SwiftUI

struct PayPalProgressBar: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            VStack {
                ProgressView("Preparing your order...")
                    .foregroundStyle(.white)
                
                    .bold()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .padding()
                
                Text("Please wait while we redirect you to PayPal")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
        }
    }
}
