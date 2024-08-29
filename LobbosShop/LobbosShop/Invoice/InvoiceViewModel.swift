////
////  InvoiceViewModel.swift
////  LobbosShop
////
////  Created by Michel Lobbos on 28.07.24.
////
//
//import Foundation
//import PDFKit
//import FirebaseFirestore
//import FirebaseAuth
//
//struct PDFDataWrapper: Identifiable {
//    let id = UUID()
//    let data: Data
//}
//
//class InvoiceViewModel: ObservableObject {
//    @Published var pdfDataWrapper: PDFDataWrapper? = nil
//    private let firestore = Firestore.firestore()
//    private let auth = Auth.auth()
//
//    func generateInvoice(order: FireOrder) async {
//        let pageBounds = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size in points
//        
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, pageBounds, nil)
//        UIGraphicsBeginPDFPageWithInfo(pageBounds, nil)
//
//        let textFont = UIFont.systemFont(ofSize: 14)
//        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        let textAttributes: [NSAttributedString.Key: Any] = [
//            .font: textFont,
//            .paragraphStyle: textStyle
//        ]
//        
//        let text = """
//        Rechnung
//        --------
//        Kunde: \(order.customerName)
//        Email: \(order.email)
//        Adresse: \(order.address), \(order.city), \(order.postalCode)
//        
//        Produkte:
//        \(order.items.map { "\($0.productName) - \($0.productPrice) € x \($0.quantity)" }.joined(separator: "\n"))
//        
//        Gesamtpreis: \(order.totalPrice) €
//        """
//        
//        let textRect = CGRect(x: 20, y: 20, width: 555.2, height: 801.8)
//        text.draw(in: textRect, withAttributes: textAttributes)
//        
//        UIGraphicsEndPDFContext()
//        
//        guard PDFDocument(data: pdfData as Data) != nil else {
//            return
//        }
//        
//        let pdfNSData = pdfData as Data
//        let invoice = FireInvoice(orderId: order.id, userId: order.userId, date: Date(), pdfData: pdfNSData)
//        
//        do {
//            try firestore.collection("invoices").addDocument(from: invoice)
//            DispatchQueue.main.async {
//                self.pdfDataWrapper = PDFDataWrapper(data: pdfNSData)
//            }
//        } catch {
//            print("Error saving invoice in Firestore: \(error)")
//        }
//    }
//}
