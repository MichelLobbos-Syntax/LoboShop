//
//  DeliveryViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 04.08.24.
//

import Foundation
import FirebaseAuth
import PDFKit

class DeliveryViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var deliveryAddress: String = ""
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var paymentMethod: String = ""
    @Published var isLoading: Bool = false
    @Published var pdfDataWrapper: PDFDataWrapper? = nil
    
    private let invoiceService = InvoiceService()
    
    func loadUserDetails(user: FireUser) {
        firstName = user.firstName ?? user.nickname
        lastName = user.lastName ?? ""
        email = user.email
        deliveryAddress = user.address ?? ""
        city = user.city ?? ""
        postalCode = user.postalCode ?? ""
        paymentMethod = user.selectedPaymentMethod ?? ""
    }
    
    func startOrderProcess(cartViewModel: CartViewModel, orderViewModel: OrdersViewModel, userViewModel: UserViewModel) async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 2_000_000_000) // simulate delay
        await placeOrder(cartViewModel: cartViewModel, orderViewModel: orderViewModel, userViewModel: userViewModel)
    }
    
    func placeOrder(cartViewModel: CartViewModel, orderViewModel: OrdersViewModel, userViewModel: UserViewModel) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("User is not signed in")
        }
        
        let newOrder = FireOrder(
            id: UUID().uuidString,
            date: Date(),
            userId: userId,
            items: cartViewModel.cartItems,
            totalPrice: cartViewModel.totalCost(),
            customerName: "\(firstName) \(lastName)",
            email: email,
            address: deliveryAddress,
            city: city,
            postalCode: postalCode,
            paymentMethod: paymentMethod
        )
        
        DispatchQueue.main.async {
            orderViewModel.addOrder(newOrder)
            cartViewModel.clearCart()
        }
        
        if var user = userViewModel.user {
            user.address = deliveryAddress
            user.city = city
            user.postalCode = postalCode
            user.selectedPaymentMethod = paymentMethod
            userViewModel.updateFirestoreUser(user: user)
        }
        
        if paymentMethod == "PayPal" {
            await PayPalViewModel().createPayment(amount: String(cartViewModel.totalCost()))
            if let approvalUrlString = PayPalViewModel().approvalUrl?.value, let url = URL(string: approvalUrlString) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    UIApplication.shared.open(url)
                }
            }
        } else if paymentMethod == "Invoice" {
            if let invoiceData = await invoiceService.generateInvoice(order: newOrder) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.pdfDataWrapper = PDFDataWrapper(data: invoiceData)
                }
                print("Invoice generated")
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Failed to generate invoice")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
