//
//  AddressView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 09.07.24.
//

import SwiftUI
import MapKit

struct AddressView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var street: String = ""
    @State private var houseNumber: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @StateObject private var searchCompleterDelegate = SearchCompleterDelegate()
    @State private var searchCompleter = MKLocalSearchCompleter()
    @State private var showSuggestions = false
    @State private var showSaveOverlay: Bool = false
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            Form {
                Section {
                    HStack {
                        TextField("Street", text: $street)
                            .onChange(of: street) { oldValue, newValue in
                                handleStreetChange(oldValue: oldValue, newValue: newValue)
                            }
                        TextField("House Number", text: $houseNumber)
                            .frame(width: 100)
                    }
                    
                    if showSuggestions {
                        List(searchCompleterDelegate.searchResults, id: \.self) { result in
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .fontWeight(.bold)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            .onTapGesture {
                                selectAddress(result)
                            }
                        }
                    }
                    
                    TextField("City", text: $city)
                    TextField("Postal Code", text: $postalCode)
                }
            }
            .scrollContentBackground(.hidden)
            if showSaveOverlay {
                VStack {
                    Text("Address updated")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .transition(.opacity)
            }
        }
        .navigationTitle("Delivery Address")
        
        .onAppear {
            if let user = userViewModel.user {
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
            searchCompleter.delegate = searchCompleterDelegate
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("Setting")
                            .foregroundColor(.white)
                        
                        
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    userViewModel.saveAddress(street: street, houseNumber: houseNumber, city: city, postalCode: postalCode)
                    showSaveOverlay = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showSaveOverlay = false
                    }
                }
                .foregroundStyle(.white)
            }
        }
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
                    street = addressComponents.dropLast().joined(separator: " ")
                    houseNumber = String(addressComponents.last!)
                } else {
                    street = item.placemark.name ?? ""
                }
                city = item.placemark.locality ?? ""
                postalCode = item.placemark.postalCode ?? ""
                showSuggestions = false
            }
        }
    }
}

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    @Published var searchResults = [MKLocalSearchCompletion]()
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddressView()
                .environmentObject(UserViewModel())
        }
    }
}
