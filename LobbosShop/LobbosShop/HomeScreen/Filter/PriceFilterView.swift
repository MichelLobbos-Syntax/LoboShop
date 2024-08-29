//
//  PriceFilterView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct PriceFilterView: View {
    @Binding var selectedPrice: Double
    @Binding var sortOption: SortOption
    
    var priceOptions: [Double] = [25, 50, 100, 150]
    
    var body: some View {
        VStack {
            HStack {
                Text("Price up to")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Reset filters
                    selectedPrice = Double.infinity
                    sortOption = .none
                }) {
                    Text("Reset Price Range")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 10) {
                ForEach(priceOptions, id: \.self) { price in
                    Button(action: {
                        selectedPrice = price
                    }) {
                        Text("\(Int(price)) $")
                            .frame(minWidth: 60, minHeight: 40)
                            .background(selectedPrice == price ? .customBackgroundColor3 : Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    selectedPrice = Double.infinity
                }) {
                    Text("Max")
                        .frame(minWidth: 50, minHeight: 40)
                        .background(selectedPrice == Double.infinity ? .customBackgroundColor3 : Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("Sort Order")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack(spacing: 10) {
                Button(action: {
                    sortOption = .none
                }) {
                    Text("None")
                        .frame(minWidth: 60, minHeight: 40)
                        .background(sortOption == .none ? .customBackgroundColor3 : Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    sortOption = .priceLowToHigh
                }) {
                    Text("Low to High")
                        .frame(minWidth: 140, minHeight: 40)
                        .background(sortOption == .priceLowToHigh ? .customBackgroundColor3 : Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    sortOption = .priceHighToLow
                }) {
                    Text("High to Low")
                        .frame(minWidth: 140, minHeight: 40)
                        .background(sortOption == .priceHighToLow ? .customBackgroundColor3 : Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal, 4)
        .padding(.vertical)
        .background(Color(UIColor.white))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
        
}

struct PriceFilterView_Previews: PreviewProvider {
    @State static var selectedPrice: Double = .infinity
    @State static var sortOption: SortOption = .none
    
    static var previews: some View {
        PriceFilterView(selectedPrice: $selectedPrice, sortOption: $sortOption)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
