//
//  PDFViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 03.08.24.
//

import Foundation
import PDFKit
import FirebaseStorage
import FirebaseFirestore

class PDFViewModel: ObservableObject {
    @Published var pdfDataWrapper: PDFDataWrapper?
    @Published var isLoading: Bool = false
    
    private let invoiceService = InvoiceService()
    
    func generateAndUploadInvoice(order: FireOrder) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        if let pdfData = await invoiceService.generateInvoice(order: order) {
            if await uploadInvoice(orderId: order.id, pdfData: pdfData) {
                DispatchQueue.main.async {
                    self.pdfDataWrapper = PDFDataWrapper(data: pdfData)
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    private func uploadInvoice(orderId: String, pdfData: Data) async -> Bool {
        return await withCheckedContinuation { continuation in
            let storageRef = Storage.storage().reference().child("invoices/\(orderId).pdf")
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            
            storageRef.putData(pdfData, metadata: metadata) { metadata, error in
                if let error = error {
                    print("Error uploading PDF: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                        return
                    }
                    
                    guard let downloadURL = url else {
                        continuation.resume(returning: false)
                        return
                    }
                    
                    let firestore = Firestore.firestore()
                    let docRef = firestore.collection("invoices").document(orderId)
                    docRef.setData(["url": downloadURL.absoluteString]) { error in
                        if let error = error {
                            print("Error saving invoice URL to Firestore: \(error.localizedDescription)")
                            continuation.resume(returning: false)
                        } else {
                            continuation.resume(returning: true)
                        }
                    }
                }
            }
        }
    }
}
