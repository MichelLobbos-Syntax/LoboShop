//
// UserViewModel.swift
// LobbosShop
// Erstellt von Michel Lobbos am 09.07.24.

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published private(set) var user: FireUser?
    @Published private(set) var userName: String?
    
    private let firebaseAuthentication = Auth.auth()
    private let firebaseFireStore = Firestore.firestore()
    
    var isUserLoggedIn: Bool {
        self.user != nil
    }
    
    init() {
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
        }
    }
    
    func login(identifier: String, password: String) {
        if identifier.contains("@") {
            firebaseAuthentication.signIn(withEmail: identifier, password: password) { authResult, error in
                if let error = error {
                    print("Error in login: \(error)")
                    return
                }
                guard let authResult = authResult else {
                    print("authResult is empty")
                    return
                }
                
                let userId = authResult.user.uid
                let userDefaults = UserDefaults(suiteName: "group.LoboShop")
                userDefaults?.set(userId, forKey: "userId")
                print("userId \(userId) gespeichert in UserDefaults.")
                
                self.fetchFirestoreUser(withId: userId)
            }
        } else {
            firebaseFireStore.collection("users").whereField("nickname", isEqualTo: identifier).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error finding user by nickname: \(error)")
                    return
                }
                guard let document = querySnapshot?.documents.first else {
                    print("No user found with nickname \(identifier)")
                    return
                }
                let data = document.data()
                let email = data["email"] as? String ?? ""
                
                self.firebaseAuthentication.signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error in login: \(error)")
                        return
                    }
                    guard let authResult = authResult else {
                        print("authResult is empty")
                        return
                    }
                    
                    let userId = authResult.user.uid
                    let userDefaults = UserDefaults(suiteName: "group.LoboShop")
                    userDefaults?.set(userId, forKey: "userId")
                    print("userId \(userId) gespeichert in UserDefaults.")
                    
                    self.fetchFirestoreUser(withId: userId)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, nickname: String) {
        firebaseAuthentication.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print("Error in sign-in: \(error)")
                return
            }
            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult or Email are empty")
                return
            }
            print("Successfully signed in with user-Id \(authResult.user.uid) and email \(userEmail)")
            
            self.createFirestoreUser(id: authResult.user.uid, email: email, nickname: nickname)
            self.fetchFirestoreUser(withId: authResult.user.uid)
            
            // Speichere die userId in den UserDefaults der App Group
            let userDefaults = UserDefaults(suiteName: "group.LoboShop")
            userDefaults?.set(authResult.user.uid, forKey: "userId")
        }
    }
    
    func logOut() {
        do {
            try firebaseAuthentication.signOut()
            closeApp()
            self.user = nil
        } catch {
            print("Error in logout: \(error)")
        }
    }
    private func closeApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    private func createFirestoreUser(id: String, email: String, nickname: String) {
        let newFireUser = FireUser(id: id, email: email, nickname: nickname, registeredAt: Date())
        
        do {
            try self.firebaseFireStore.collection("users").document(id).setData(from: newFireUser)
        } catch {
            print("Error saving user in firestore: \(error)")
        }
    }
    
    func fetchFirestoreUser(withId id: String) {
        self.firebaseFireStore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error fetching user: \(error)")
                return
            }
            
            guard let document else {
                print("Document does not exist")
                return
            }
            
            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }
    
    func updateFirestoreUser(user: FireUser) {
        do {
            try self.firebaseFireStore.collection("users").document(user.id).setData(from: user)
            self.user = user
        } catch {
            print("Error updating user in firestore: \(error)")
        }
    }
    
    func loadUserDetails() -> (firstName: String, lastName: String, email: String, street: String, houseNumber: String, city: String, postalCode: String, paymentMethod: String)? {
        guard let user = user else { return nil }
        let addressComponents = user.address?.split(separator: " ") ?? []
        let street = addressComponents.dropLast().joined(separator: " ")
        let houseNumber = String(addressComponents.last ?? "")
        return (
            firstName: user.firstName ?? "",
            lastName: user.lastName ?? "",
            email: user.email,
            street: street,
            houseNumber: houseNumber,
            city: user.city ?? "",
            postalCode: user.postalCode ?? "",
            paymentMethod: user.selectedPaymentMethod ?? ""
        )
    }
    
    func saveProfile(nickname: String, firstName: String, lastName: String) {
        if var user = self.user {
            if nickname != "" {
                user.nickname = nickname
                user.firstName = firstName
                user.lastName = lastName
                self.updateFirestoreUser(user: user)
                print("Profile saved: \(user)")
            }
        }
    }
    
    func saveAddress(street: String, houseNumber: String, city: String, postalCode: String) {
        if var user = self.user {
            let fullAddress = "\(street) \(houseNumber)"
            user.address = fullAddress
            user.city = city
            user.postalCode = postalCode
            self.updateFirestoreUser(user: user)
            print("Address saved: \(user)")
        }
    }
}
