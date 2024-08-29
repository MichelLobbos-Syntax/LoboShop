//
// PayPalService.swift
// LobbosShop
// Erstellt von Michel Lobbos am 21.07.24.

import Foundation

class PayPalService {
    // Singleton-Instanz des PayPalService
    static let shared = PayPalService()
    
    // PayPal Client-ID und Secret-Schlüssel
    private let clientID = PaypalKeys.clientID.rawValue
    private let secret = PaypalKeys.secret.rawValue
    
    // Funktion zum Abrufen des Zugriffstokens von PayPal
    func getAccessToken() async throws -> String {
        // URL zum Abrufen des Tokens
        let url = URL(string: "https://api.sandbox.paypal.com/v1/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Kodierung der Client-Zugangsdaten für die Basic Authentifizierung
        let credentials = "\(clientID):\(secret)".data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        // Anfrage an die PayPal API ausführen und auf Antwort warten
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Überprüfen, ob die Antwort gültig ist (Statuscode 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ungültige Antwort"])
        }
        
        // JSON-Antwort parsen
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let accessToken = json["access_token"] as? String else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ungültige JSON-Struktur"])
        }
        
        // Zugriffstoken zurückgeben
        return accessToken
    }
    
    // Funktion zum Erstellen einer Zahlung mit Zugriffstoken und Betrag
    func createPayment(accessToken: String, amount: String) async throws -> String {
        // URL zum Erstellen einer Zahlung
        let url = URL(string: "https://api.sandbox.paypal.com/v1/payments/payment")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Authentifizierungstoken in den Header setzen
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Zahlungsdetails im PayPalPayment-Modell erstellen
        let paymentDetails = PayPalPayment(
            intent: "sale", // Verkaufsabsicht
            payer: Payer(payment_method: "paypal"), // Zahler-Informationen
            transactions: [
                Transaction(amount: Amount(total: amount, currency: "USD"), description: "Dies ist die Zahlungsbeschreibung.")
            ],
            redirect_urls: RedirectUrls(return_url: "https://example.com/return", cancel_url: "https://example.com/cancel")
        )
        
        // Zahlungsdetails in JSON kodieren
        let jsonData = try JSONEncoder().encode(paymentDetails)
        request.httpBody = jsonData
        
        // Anfrage an die PayPal API ausführen und auf Antwort warten
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Überprüfen, ob die Antwort gültig ist (Statuscode 201)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ungültige Antwort"])
        }
        
        // JSON-Antwort parsen
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let links = json["links"] as? [[String: Any]] else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ungültige JSON-Struktur"])
        }
        
        // Genehmigungs-URL aus den Links extrahieren
        for link in links {
            if let rel = link["rel"] as? String, rel == "approval_url", let approvalUrl = link["href"] as? String {
                return approvalUrl
            }
        }
        
        // Fehler werfen, wenn keine Genehmigungs-URL gefunden wird
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Keine Genehmigungs-URL gefunden"])
    }
}
