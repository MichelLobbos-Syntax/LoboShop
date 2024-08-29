////
////  PDFPreviewView.swift
////  LobbosShop
////
////  Created by Michel Lobbos on 28.07.24.
////
//
//import SwiftUI
//import PDFKit
//
//struct PDFPreviewView: View {
//    let data: Data
//    
//    var body: some View {
//        VStack {
//            PDFKitRepresentedView(data)
//                .edgesIgnoringSafeArea(.all)
//            
//            Button(action: {
//                takeScreenshot()
//            }) {
//                Text("Screenshot")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//    }
//    
//    func takeScreenshot() {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({ $0.activationState == .foregroundActive })
//            .compactMap({ $0 as? UIWindowScene })
//            .first?.windows
//            .filter({ $0.isKeyWindow }).first
//
//        let renderer = UIGraphicsImageRenderer(size: keyWindow!.bounds.size)
//        let image = renderer.image { ctx in
//            keyWindow!.drawHierarchy(in: keyWindow!.bounds, afterScreenUpdates: true)
//        }
//
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//    }
//}
//
//struct PDFKitRepresentedView: UIViewRepresentable {
//    let data: Data
//    
//    init(_ data: Data) {
//        self.data = data
//    }
//    
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(data: data)
//        pdfView.autoScales = true
//        return pdfView
//    }
//    
//    func updateUIView(_ pdfView: PDFView, context: Context) {
//        // No update necessary
//    }
//}
