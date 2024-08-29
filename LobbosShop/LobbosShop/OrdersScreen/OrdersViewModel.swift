//
// OrdersViewModel.swift
// LobbosShop
// Erstellt von Michel Lobbos am 09.07.24.

// OrdersViewModel.swift

import Foundation
import FirebaseFirestore
import FirebaseAuth

class OrdersViewModel: ObservableObject {
    // Veröffentlichtes Array zur Verwaltung der Bestellungen
    @Published var orders: [FireOrder] = []
    // Veröffentlichtes Array zur Verwaltung der Bewertungen
    @Published var ratings: [FireRating] = []
    
    private let firebaseFirestore = Firestore.firestore()
    private let firebaseAuth = Auth.auth()
    // Listener zur Überwachung von Änderungen an der Orders-Sammlung
    private var ordersListener: ListenerRegistration?
    // Listener zur Überwachung von Änderungen an der Ratings-Sammlung
    private var ratingsListener: ListenerRegistration?
    // ViewModel zur Verwaltung der Benutzerdaten
    private var userViewModel: UserViewModel
    
    // Initialisierung und Abrufen der Bestellungen
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        fetchOrders()
        fetchAllRatings()
    }
    // Methode zum Hinzufügen einer Bestellung
    func addOrder(_ order: FireOrder) {
        guard let userId = firebaseAuth.currentUser?.uid else {
            fatalError("User is not signed in")
        }
        var orderWithUserId = order
        orderWithUserId.userId = userId // Benutzer-ID zur Bestellung hinzufügen
        do {
            // Bestellung in Firestore speichern
            try firebaseFirestore.collection("orders").addDocument(from: orderWithUserId)
        } catch {
            print("Error saving order in Firestore: \(error)")
        }
    }
    
    // Methode zum Abrufen der Bestellungen aus Firestore
    func fetchOrders() {
        guard let userId = firebaseAuth.currentUser?.uid else {
            fatalError("User is not signed in") // Fehler, wenn der Benutzer nicht angemeldet ist
        }
        
        // Listener zur Überwachung von Änderungen an der Sammlung "orders"
        ordersListener = firebaseFirestore.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching orders: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty")
                    return
                }
                
                // Aktualisieren der orders mit den abgerufenen Daten
                self.orders = snapshot.documents.compactMap { document -> FireOrder? in
                    try? document.data(as: FireOrder.self)
                }
            }
    }
    
    // Methode zum Abrufen der Bewertungen für ein Produkt
    func fetchRatingsForProduct(productId: Int) {
        firebaseFirestore.collection("ratings")
            .whereField("productId", isEqualTo: productId)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching ratings for product: \(error)")
                    return
                }
                
                self.ratings = snapshot?.documents.compactMap { document -> FireRating? in
                    try? document.data(as: FireRating.self)
                } ?? []
            }
    }
    
    // Methode zum Abrufen aller Bewertungen
    func fetchAllRatings() {
        ratingsListener = firebaseFirestore.collection("ratings")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching ratings: \(error)") // Fehlerbehandlung
                    return
                }
                
                // Aktualisieren der ratings mit den abgerufenen Daten
                self.ratings = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: FireRating.self)
                } ?? []
            }
    }
    
    // Methode zum Speichern einer Bewertung
    func saveRating(_ rating: FireRating) {
        guard let nickname = userViewModel.user?.nickname else {
            fatalError("User nickname not available")
        }
        
        var newRating = rating
        newRating.userId = nickname // Benutzername zur Bewertung hinzufügen
        do {
            // Bewertung in Firestore speichern
            try firebaseFirestore.collection("ratings").addDocument(from: newRating)
        } catch {
            print("Error saving rating in Firestore: \(error)")
        }
    }
    
    // Methode zum erneuten Abrufen die Bewertungen
    func reloadOrders() {
        fetchAllRatings()
    }
    
    // Methode zur Berechnung des durchschnittlichen Ratings eines Produkts
    func averageRating(for productId: Int) -> Double {
        let productRatings = ratings.filter { $0.productId == productId }
        guard !productRatings.isEmpty else {
            return 0.0
        }
        let totalRating = productRatings.map(\.rating).reduce(0 , +)
        return totalRating / Double(productRatings.count)
    }
    
    deinit {
        ordersListener?.remove()
        ratingsListener?.remove()
    }
}
