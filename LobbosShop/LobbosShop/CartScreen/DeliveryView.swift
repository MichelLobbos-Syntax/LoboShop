import SwiftUI
import FirebaseStorage
import FirebaseAuth
import PDFKit
import FirebaseFirestore

struct DeliveryView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @EnvironmentObject var orderViewModel: OrdersViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var payPalViewModel = PayPalViewModel()
    @Binding var selectedTab: Int
    @Binding var showingSheet: Bool
    
    @State private var street: String = ""
    @State private var houseNumber: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    
    @State private var paymentMethod: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var pdfDataWrapper: PDFDataWrapper? = nil
    
    private let invoiceService = InvoiceService()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("Personal Information")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)) {
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(firstName.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lastName.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(true)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(email.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                    
                    Section(header: Text("Delivery Address")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)) {
                            HStack {
                                TextField("Street", text: $street)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(street.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                TextField("House Number", text: $houseNumber)
                                    .frame(width: 100)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(houseNumber.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            
                            TextField("City", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(city.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                )
                            
                            TextField("Postal Code", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(postalCode.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                    
                    Section(header: Text("Payment Method")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)) {
                            Picker("Payment Method", selection: $paymentMethod) {
                                Text("Invoice").tag("Invoice")
                                Text("PayPal").tag("PayPal")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(paymentMethod.isEmpty ? Color.red : Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        }
                    
                    Section {
                        Button(action: {
                            Task {
                                await startOrderProcess()
                            }
                        }) {
                            Text("Confirm and Order")
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(isFormValid() ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!isFormValid())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .blur(radius: isLoading ? 3.0 : 0)
            .disabled(isLoading)
            .overlay(
                Group {
                    if paymentMethod == "PayPal" {
                        PayPalProgressBar(isLoading: $isLoading)
                    } else if paymentMethod == "Invoice" {
                        InvoiceProgressBar(isLoading: $isLoading)
                    }
                }
            )
            .navigationTitle("Delivery Details")
            .onAppear {
                reloadUserDetails()
            }
            .onChange(of: userViewModel.user) { _, _ in
                reloadUserDetails()
            }
            .navigationBarItems(trailing: Button(action: {
                showingSheet = false
                reloadUserDetails()
            }) {
                Text("Cancel")
            })
            .alert(item: $payPalViewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage.value), dismissButton: .default(Text("OK")))
            }
            .fullScreenCover(item: $pdfDataWrapper) { wrapper in
                PDFPreviewView(data: wrapper.data, selectedTab: $selectedTab, showingSheet: $showingSheet)
            }
        }
    }
    
    // Funktion zur Validierung des Formulars
    func isFormValid() -> Bool {
        return !firstName.isEmpty &&
        !lastName.isEmpty &&
        !street.isEmpty &&
        !houseNumber.isEmpty &&
        !city.isEmpty &&
        !postalCode.isEmpty &&
        !paymentMethod.isEmpty
    }
    
    
    
    func reloadUserDetails() {
        if let userId = Auth.auth().currentUser?.uid {
            userViewModel.fetchFirestoreUser(withId: userId)
        }
        if let details = userViewModel.loadUserDetails() {
            firstName = details.firstName
            lastName = details.lastName
            email = details.email
            street = details.street
            houseNumber = details.houseNumber
            city = details.city
            postalCode = details.postalCode
            paymentMethod = details.paymentMethod
        }
    }
    func startOrderProcess() async {
        isLoading = true
        await placeOrder()
        isLoading = false
    }
    
    func placeOrder() async {
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
            address: "\(street) \(houseNumber)",
            city: city,
            postalCode: postalCode,
            paymentMethod: paymentMethod
        )
        
        // Hinzufügen der Bestellung in das ViewModel
        DispatchQueue.main.async {
            self.orderViewModel.addOrder(newOrder)
        }
        
        cartViewModel.clearCart()
        
        if var user = userViewModel.user {
            user.address = "\(street) \(houseNumber)"
            user.city = city
            user.postalCode = postalCode
            user.selectedPaymentMethod = paymentMethod
            userViewModel.updateFirestoreUser(user: user)
        }
        
        if paymentMethod == "PayPal" {
            await payPalViewModel.createPayment(amount: String(cartViewModel.totalCost()))
            if let approvalUrlString = payPalViewModel.approvalUrl?.value, let url = URL(string: approvalUrlString) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    UIApplication.shared.open(url)
                }
            }
        } else if paymentMethod == "Invoice" {
            await generateAndUploadInvoice(order: newOrder)
        }
    }
    
    func generateAndUploadInvoice(order: FireOrder) async {
        if let pdfData = await invoiceService.generateInvoice(order: order) {
            if await uploadInvoice(orderId: order.id, pdfData: pdfData) {
                DispatchQueue.main.async {
                    self.pdfDataWrapper = PDFDataWrapper(data: pdfData)
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to upload invoice")
                }
            }
        } else {
            DispatchQueue.main.async {
                print("Failed to generate invoice")
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
