//
//  OrderRowView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI

struct OrderRowView: View {
    let order: FireOrder
    @State private var expanded = false
    @EnvironmentObject var ordersViewModel: OrdersViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if expanded {
                Text("Order ID: \(order.id)")
                    .font(.headline)
            } else {
                Text("Order: \(order.id.prefix(16))...")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text("Date: \(order.date, formatter: dateFormatter)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Total Price: \(order.totalPrice, specifier: "%.2f") €")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            if expanded {
                ForEach(order.items, id: \.id) { item in
                    OrderItemView(item: item)
                        .padding(.vertical, 4)
                        .environmentObject(ordersViewModel)
                        .onTapGesture {
                            
                        }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .onTapGesture {
            withAnimation {
                expanded.toggle()
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
