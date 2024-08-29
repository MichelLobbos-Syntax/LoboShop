//
//  GradientBackgroundView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 18.07.24.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}


