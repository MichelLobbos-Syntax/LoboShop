import SwiftUI
import PDFKit

struct PDFPreviewView: View {
    let data: Data
    @Binding var selectedTab: Int
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack {
            PDFKitRepresentedView(data)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                
                selectedTab = 0
                showingSheet = false
            }) {
                Text("Back to Home")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // No update necessary
    }
}
