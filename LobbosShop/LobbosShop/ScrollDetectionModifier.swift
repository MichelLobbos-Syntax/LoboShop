//
//  ScrollDetectionModifier.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 10.07.24.
//

import SwiftUI

struct ScrollDetectionModifier: ViewModifier {
    @Binding var isScrollingDown: Bool
    @State private var previousOffset: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .background(
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .global).minY)
                )
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            if value < previousOffset {
                isScrollingDown = true
            } else if value > previousOffset {
                isScrollingDown = false
            }
            previousOffset = value
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func detectScrollDirection(isScrollingDown: Binding<Bool>) -> some View {
        self.modifier(ScrollDetectionModifier(isScrollingDown: isScrollingDown))
    }
}
