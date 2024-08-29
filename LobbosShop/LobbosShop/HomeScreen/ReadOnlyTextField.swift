//
//  ReadOnlyTextField.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 04.08.24.
//

import SwiftUI

struct ReadOnlyTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(text.isEmpty ? placeholder : text)
                .foregroundColor(text.isEmpty ? .gray : .primary)
                .padding(.vertical, 10)
            Spacer()
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

struct ReadOnlyTextField_Previews: PreviewProvider {
    static var previews: some View {
        ReadOnlyTextField(placeholder: "Email", text: .constant("example@example.com"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
