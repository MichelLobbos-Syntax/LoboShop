//
//  ScrollViewProxy.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 10.07.24.
//

import SwiftUI
import UIKit

struct ScrollViewProxy: UIViewRepresentable {
    var onScroll: (CGFloat) -> Void
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewProxy
        
        init(_ parent: ScrollViewProxy) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // No updates needed
    }
}
