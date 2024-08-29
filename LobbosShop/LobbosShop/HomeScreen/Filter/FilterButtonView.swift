//
//  FilterButtonView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct FilterButtonView: View {
    let title: String
    let icon: String
    @Binding var selectedCategory: String?
    let category: String?
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectedCategory = category
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(selectedCategory == category ? .white : .primary)
                Text(title)
                    .foregroundStyle(selectedCategory == category ? .white : .primary)
            }
            .padding()
            .background(selectedCategory == category ? Color.customBackgroundColor3 : Color.white)
            .cornerRadius(10)
            .shadow(color: selectedCategory == category ? Color.white.opacity(0.5) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 0)
            .scaleEffect(selectedCategory == category ? 1.05 : 1.0)
            .rotation3DEffect(
                Angle(degrees: selectedCategory == category ? 5 : 0),
                axis: (x: 10.0, y: 10.0, z: 0.0)
            )
            .padding(.vertical)
                    }
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    @State static var selectedCategory: String? = "All"

    static var previews: some View {
        Group {
            VStack(spacing: 10) {
                FilterButtonView(title: "All", icon: "rectangle.grid.2x2", selectedCategory: $selectedCategory, category: nil)
                FilterButtonView(title: "Electronics", icon: "ipad", selectedCategory: $selectedCategory, category: "electronics")
                FilterButtonView(title: "Jewelery", icon: "sparkles", selectedCategory: $selectedCategory, category: "jewelery")
                FilterButtonView(title: "Men's Clothing", icon: "tshirt", selectedCategory: $selectedCategory, category: "men's clothing")
                FilterButtonView(title: "Women's Clothing", icon: "handbag", selectedCategory: $selectedCategory, category: "women's clothing")
            }
            .padding()
            .previewDisplayName("Light Mode")
            .environment(\.colorScheme, .light)
            
            VStack(spacing: 10) {
                FilterButtonView(title: "All", icon: "rectangle.grid.2x2", selectedCategory: $selectedCategory, category: nil)
                FilterButtonView(title: "Electronics", icon: "ipad", selectedCategory: $selectedCategory, category: "electronics")
                FilterButtonView(title: "Jewelery", icon: "sparkles", selectedCategory: $selectedCategory, category: "jewelery")
                FilterButtonView(title: "Men's Clothing", icon: "tshirt", selectedCategory: $selectedCategory, category: "men's clothing")
                FilterButtonView(title: "Women's Clothing", icon: "handbag", selectedCategory: $selectedCategory, category: "women's clothing")
            }
            .padding()
            .previewDisplayName("Dark Mode")
            .environment(\.colorScheme, .dark)
        }
    }
}
