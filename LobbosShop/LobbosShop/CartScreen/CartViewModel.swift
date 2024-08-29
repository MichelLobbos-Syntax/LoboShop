import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class CartViewModel: ObservableObject {
    // Veröffentlichtes Array zur Verwaltung der Einkaufswagenartikel
    @Published var cartItems: [FireCartItem] = []
    
    private let firebaseAuth = Auth.auth() // Firebase-Authentifizierungsinstanz
    private let firebaseFirestore = Firestore.firestore() // Firebase-Firestore-Instanz
    private var listener: ListenerRegistration? // Listener zur Überwachung von Änderungen an der Firestore-Sammlung
    
    // Initialisierung und Abrufen der Einkaufswagenartikel
    init() {
        fetchCartItems()
    }
    
    // Methode zum Hinzufügen von Artikeln in den Einkaufswagen
    func addToCart(_ product: Product, quantity: Int, color: String, size: String) {
        guard let userId = firebaseAuth.currentUser?.uid else {
            fatalError("User is not signed in") // Fehler, wenn der Benutzer nicht angemeldet ist
        }
        
        // Überprüfen, ob der Artikel bereits im Einkaufswagen vorhanden ist
        if let index = cartItems.firstIndex(where: { $0.productId == product.id && $0.color == color && $0.size == size }) {
            updateQuantity(productId: product.id, quantity: cartItems[index].quantity + quantity, color: color, size: size) // Menge aktualisieren, wenn der Artikel bereits vorhanden ist
        } else {
            let newCartItem = FireCartItem(id: UUID().uuidString, userId: userId, productId: product.id, productName: product.title, productPrice: product.price, quantity: quantity, color: color, size: size, productImage: product.image)
            do {
                try firebaseFirestore.collection("cartItems").document(newCartItem.id).setData(from: newCartItem) // Neuen Artikel zum Einkaufswagen hinzufügen
            } catch {
                print("Error adding item to cart: \(error)") // Fehlerbehandlung
            }
        }
    }
    
    // Methode zur Aktualisierung der Menge eines Artikels im Einkaufswagen
    func updateQuantity(productId: Int, quantity: Int, color: String, size: String) {
        guard (firebaseAuth.currentUser?.uid) != nil else {
            fatalError("User is not signed in") // Fehler, wenn der Benutzer nicht angemeldet ist
        }
        
        // Artikel im Einkaufswagen finden und Menge aktualisieren
        if let cartItem = cartItems.first(where: { $0.productId == productId && $0.color == color && $0.size == size }) {
            firebaseFirestore.collection("cartItems").document(cartItem.id).updateData(["quantity": quantity]) { error in
                if let error {
                    print("Error updating quantity: \(error)") // Fehlerbehandlung
                }
            }
        }
    }
    
    // Methode zum Entfernen eines Artikels aus dem Einkaufswagen
    func removeFromCart(productId: Int, color: String, size: String) {
        guard let cartItem = cartItems.first(where: { $0.productId == productId && $0.color == color && $0.size == size }) else { return }
        firebaseFirestore.collection("cartItems").document(cartItem.id).delete() { error in
            if let error {
                print("Error removing item from cart: \(error)") // Fehlerbehandlung
            }
        }
    }
    
    // Methode zur Berechnung der Gesamtkosten des Einkaufswagens
    func totalCost() -> Double {
        cartItems.reduce(0) { $0 + $1.productPrice * Double($1.quantity) }
    }
    
    // Methode zum Leeren des gesamten Einkaufswagens
    func clearCart() {
        guard (firebaseAuth.currentUser?.uid) != nil else {
            fatalError("User is not signed in") // Fehler, wenn der Benutzer nicht angemeldet ist
        }
        
        for item in cartItems {
            firebaseFirestore.collection("cartItems").document(item.id).delete() { error in
                if let error {
                    print("Error clearing cart item: \(error)") // Fehlerbehandlung
                }
            }
        }
    }
    
    // Methode zum Abrufen der Einkaufswagenartikel aus Firestore
    func fetchCartItems() {
        guard let userId = firebaseAuth.currentUser?.uid else {
            fatalError("User is not signed in") // Fehler, wenn der Benutzer nicht angemeldet ist
        }
        
        // Listener zur Überwachung von Änderungen an der Sammlung "cartItems"
        self.listener = firebaseFirestore.collection("cartItems")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Error fetching cart items: \(error)") // Fehlerbehandlung
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Snapshot is empty") // Fehlerbehandlung, wenn der Snapshot leer ist
                    return
                }
                
                // Aktualisieren der cartItems mit den abgerufenen Daten
                self.cartItems = snapshot.documents.compactMap { document -> FireCartItem? in
                    try? document.data(as: FireCartItem.self)
                }
            }
    }
}
