//
//  RatingViewModel.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 13.07.24.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//
//class RatingViewModel: ObservableObject {
//    @Published var ratings: [FireRating] = []
//    
//    private let firebaseFirestore = Firestore.firestore()
//    private let firebaseAuth = Auth.auth()
//    
//    func saveRating(_ rating: FireRating) {
//        do {
//            try firebaseFirestore.collection("ratings").document(rating.id).setData(from: rating)
//            ratings.append(rating)
//        } catch {
//            print("Error saving rating in Firestore: \(error)")
//        }
//    }
//    
//    func fetchRatings(for userId: String) {
//        firebaseFirestore.collection("ratings")
//            .whereField("userId", isEqualTo: userId)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error fetching ratings: \(error)")
//                    return
//                }
//                
//                self.ratings = querySnapshot?.documents.compactMap { document in
//                    try? document.data(as: FireRating.self)
//                } ?? []
//            }
//    }
//}
