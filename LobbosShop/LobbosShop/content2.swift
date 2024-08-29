//
//  content2.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 25.07.24.
//

//import SwiftUI
//
//struct content2: View {
//    @State private var progress: CGFloat = 0.0
//        @State private var timer: Timer?
//
//        var body: some View {
//            VStack {
//                AnimatedProgressBar(progress: $progress)
//                    .frame(height: 50)
//                
//                HStack {
//                    Button("Start Progress") {
//                        startProgress()
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    
//                    Button("Reset Progress") {
//                        resetProgress()
//                    }
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//            }
//            .padding()
//        }
//        
//        func startProgress() {
//            resetProgress()
//            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
//                if progress < 1.0 {
//                    progress += 0.01
//                } else {
//                    timer?.invalidate()
//                }
//            }
//        }
//        
//        func resetProgress() {
//            timer?.invalidate()
//            progress = 0.0
//        }
//}
//
//#Preview {
//    content2()
//}
