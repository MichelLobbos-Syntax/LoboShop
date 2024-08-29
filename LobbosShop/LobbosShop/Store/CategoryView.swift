//
//  CategoryView.swift
//  LobbosShop
//
//  Created by Michel Lobbos on 07.07.24.
//

import SwiftUI


struct CategoryView: View {
    @Binding var selectedCategoryId: Int?
    @ObservedObject var viewModel: ProductViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button("Alle") {
                    self.selectedCategoryId = nil
                }
                .padding(10)
                .background(self.selectedCategoryId == nil ? Color.gray.opacity(0.2) : Color.clear)
                .cornerRadius(10)

                ForEach(viewModel.categories, id: \.id) { category in
                    Button(action: {
                        self.selectedCategoryId = category.id
                    }) {
                        VStack {
                                                        if let url = URL(string: category.image) {
                                                            AsyncImage(url: url) { image in
                                                                image.resizable()
                                                                     .aspectRatio(contentMode: .fill)
                                                                     .frame(width: 100, height: 100)
                                                                     .clipShape(Circle())
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                        }
                                                        Text(category.name)
                                                            .font(.caption)
                                                            .foregroundColor(self.selectedCategoryId == category.id ? .blue : .black)
                                                    }
                                                    .padding(10)
                                                    .background(self.selectedCategoryId == category.id ? Color.gray.opacity(0.2) : Color.clear)
                                                    .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


//struct CategoryView: View {
//    @StateObject var viewModel = CategoryViewModel()
//    @State private var selectedCategoryId: Int? // Zum Speichern der ausgewählten Kategorie-ID
//
//    var body: some View {
//        
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(viewModel.categories, id: \.id) { category in
//                        Button(action: {
//                            // Aktion, wenn Button gedrückt wird
//                            self.selectedCategoryId = category.id
//                            // Hier könntest du auch eine Funktion aufrufen, die Filter anwendet, basierend auf der Kategorie
//                        }) {
//                            VStack {
//                                if let url = URL(string: category.image) {
//                                    AsyncImage(url: url) { image in
//                                        image.resizable()
//                                             .aspectRatio(contentMode: .fill)
//                                             .frame(width: 100, height: 100)
//                                             .clipShape(Circle())
//                                    } placeholder: {
//                                        ProgressView()
//                                    }
//                                }
//                                Text(category.name)
//                                    .font(.caption)
//                                    .foregroundColor(self.selectedCategoryId == category.id ? .blue : .black)
//                            }
//                            .padding(10)
//                            .background(self.selectedCategoryId == category.id ? Color.gray.opacity(0.2) : Color.clear)
//                            .cornerRadius(10)
//                        }
//                    }
//                }
//                .padding(.horizontal)
//            }
//            
//            .onAppear {
//                viewModel.loadCategories()
//            }
//        
//    }
//}
//
//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//    }
//}
