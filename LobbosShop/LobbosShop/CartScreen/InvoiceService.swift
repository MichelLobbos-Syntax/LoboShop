//
//  InvoiceService.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 26.07.24.


import Foundation
import PDFKit
import FirebaseStorage
import FirebaseFirestore


class InvoiceService {
    // Firebase Storage und Firestore Referenzen
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()
    
    // Asynchrone Methode zum Generieren der Rechnung als PDF-Dokument
    func generateInvoice(order: FireOrder) async -> Data? {
        return await withCheckedContinuation { continuation in
            // Definieren der Abmessungen der PDF-Seite (A4-Größe)
            let pageBounds = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
            
            // Erstellen eines neuen PDF-Dokuments im Speicher
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, pageBounds, nil)
            UIGraphicsBeginPDFPageWithInfo(pageBounds, nil)
            
            // Festlegen der Schriftart und Textattribute
            let textFont = UIFont.systemFont(ofSize: 16)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: textFont
            ]
            // Definieren des Inhalts der Rechnung
            let content = """
            Invoice
            LoboShop
            ---------------
            Customer: \(order.customerName)
            Email: \(order.email)
            Address: \(order.address), \(order.city), \(order.postalCode)
            ------------------------------
            Products:
            \(order.items.map { "\($0.productName) - \($0.productPrice) € x \($0.quantity)" }.joined(separator: "\n"))
            
            Total Price: \(order.totalPrice) €
            ---------------------------------------------
            IBAN: DE00 0000 0000 0000 0000 00
            BIC: ABCDDEFFXXX
            ------------------------------------------------------------
            Please transfer the total amount within 14 days to the account mentioned above.
            The payment due date is \(Date().addingTimeInterval(14*24*60*60).formattedDate()).
            ---------------------------------------------------------------------------
            Thank you for your purchase at LoboShop!
            We look forward to seeing you again soon.
            """
            
            // Definieren des Bereichs, in dem der Text auf der PDF-Seite gezeichnet wird
            let textRect = CGRect(x: 20, y: 40, width: 555.2, height: 801.8)
            content.draw(in: textRect, withAttributes: textAttributes)
            
            // Beenden des PDF-Kontexts
            UIGraphicsEndPDFContext()
            
            // Überprüfen, ob das PDF-Dokument erfolgreich erstellt wurde
            guard PDFDocument(data: pdfData as Data) != nil else {
                continuation.resume(returning: nil)
                return
            }
            
            // Definieren des Speicherpfads in Firebase Storage
            let storageRef = storage.reference().child("invoices/\(order.id).pdf")
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            
            // Hochladen der PDF-Daten zu Firebase Storage
            storageRef.putData(pdfData as Data, metadata: metadata) { metadata, error in
                if let error = error {
                    // Fehler beim Hochladen der PDF-Datei
                    print("Error uploading PDF: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }
                
                // Abrufen der Download-URL der hochgeladenen PDF-Datei
                storageRef.downloadURL { url, error in
                    if let error = error {
                        // Fehler beim Abrufen der Download-URL
                        print("Error getting download URL: \(error.localizedDescription)")
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    // Überprüfen, ob die URL erfolgreich abgerufen wurde
                    guard let downloadURL = url else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    // Speichern der Download-URL in Firestore
                    self.saveInvoiceURLToFirestore(orderId: order.id, url: downloadURL) { success in
                        if success {
                            // Erfolgreich gespeichert, Rückgabe der PDF-Daten
                            continuation.resume(returning: pdfData as Data)
                        } else {
                            continuation.resume(returning: nil)
                        }
                    }
                }
            }
        }
    }
    
    // Methode zum Speichern der Download-URL der Rechnung in Firestore
    private func saveInvoiceURLToFirestore(orderId: String, url: URL, completion: @escaping (Bool) -> Void) {
        // Referenz zum entsprechenden Dokument in der "invoices"-Sammlung
        let docRef = firestore.collection("invoices").document(orderId)
        
        // Speichern der URL im Dokument
        docRef.setData(["url": url.absoluteString]) { error in
            if let error = error {
                // Fehler beim Speichern der URL
                print("Error saving invoice URL to Firestore: \(error.localizedDescription)")
                completion(false)
            } else {
                // Erfolgreich gespeichert
                completion(true)
            }
        }
    }
}

// Erweiterung für das Date-Objekt zum Formatieren des Datums
extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
