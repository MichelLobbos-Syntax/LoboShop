//
// PayPalViewModel.swift
// LobbosShop
// Erstellt von Michel Lobbos am 21.07.24.

import Foundation

class PayPalViewModel: ObservableObject {
    // Verwaltung der Genehmigungs-URL
    @Published var approvalUrl: IdentifiableString?
    // Verwaltung von Fehlermeldungen
    @Published var errorMessage: IdentifiableStringWrapper?
    
    // Funktion zur Erstellung einer Zahlung
    func createPayment(amount: String) async {
        do {
            print("createPayment aufgerufen mit Betrag: \(amount)")
            // Zugriffstoken von PayPal abrufen
            let accessToken = try await PayPalService.shared.getAccessToken()
            print("Access Token erhalten: \(accessToken)")
            // Zahlung erstellen und Genehmigungs-URL abrufen
            let url = try await PayPalService.shared.createPayment(accessToken: accessToken, amount: amount)
            print("Approval URL erhalten: \(url)")
            DispatchQueue.main.async {
                self.approvalUrl = IdentifiableString(value: url) 
                print("approvalUrl im ViewModel gesetzt: \(self.approvalUrl?.value ?? "Keine URL")")
            }
        } catch {
            print("Fehler bei der Zahlungserstellung: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.errorMessage = IdentifiableStringWrapper(value: error.localizedDescription)
            }
        }
    }
}


