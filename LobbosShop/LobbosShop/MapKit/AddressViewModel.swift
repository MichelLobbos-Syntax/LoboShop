//
//  AddressViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 04.08.24.
//

import SwiftUI
import MapKit

class AddressViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var street: String = ""
    @Published var houseNumber: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var showSuggestions = false
    @Published var searchResults = [MKLocalSearchCompletion]()
    
    @Published var user: FireUser?
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    func handleStreetChange(oldValue: String, newValue: String) {
        searchCompleter.queryFragment = newValue
        showSuggestions = true
    }
    
    func selectAddress(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let response = response, let item = response.mapItems.first {
                let addressComponents = item.placemark.name?.split(separator: " ") ?? []
                if addressComponents.count > 1 {
                    self.street = addressComponents.dropLast().joined(separator: " ")
                    self.houseNumber = String(addressComponents.last!)
                } else {
                    self.street = item.placemark.name ?? ""
                }
                self.city = item.placemark.locality ?? ""
                self.postalCode = item.placemark.postalCode ?? ""
                self.showSuggestions = false
            }
        }
    }
    
    func loadUserAddress(user: FireUser) {
        self.user = user
        let addressComponents = user.address?.split(separator: " ") ?? []
        if addressComponents.count > 1 {
            street = addressComponents.dropLast().joined(separator: " ")
            houseNumber = String(addressComponents.last!)
        } else {
            street = user.address ?? ""
        }
        city = user.city ?? ""
        postalCode = user.postalCode ?? ""
    }
    
    func saveAddress(userViewModel: UserViewModel) {
        guard let user = user else { return }
        let fullAddress = "\(street) \(houseNumber)"
        let updatedUser = FireUser(
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            firstName: user.firstName,
            lastName: user.lastName,
            registeredAt: user.registeredAt,
            address: fullAddress,
            city: city,
            postalCode: postalCode
        )
        userViewModel.updateFirestoreUser(user: updatedUser)
        print("Address saved: \(updatedUser)")
    }
    
    // MKLocalSearchCompleterDelegate methods
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
