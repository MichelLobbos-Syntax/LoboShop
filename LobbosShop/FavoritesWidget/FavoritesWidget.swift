//
//  FavoritesWidget.swift
//  FavoritesWidget
//
//  Created by Michel Lobbos on 10.07.24.
//

import WidgetKit
import SwiftUI

// Erweiterungen für benutzerdefinierte Farben
extension Color {
    static let customBackgroundColor1 = Color(red: 110/255, green: 139/255, blue: 252/255)
    static let customBackgroundColor2 = Color(red: 131/255, green: 238/255, blue: 252/255)
    static let customBackgroundColor3 = Color(red: 116/255, green: 165/255, blue: 252/255)
}

struct FavoriteEntry: TimelineEntry {
    let date: Date
    let product: Product?
}

struct FavoritesProvider: TimelineProvider {
    func placeholder(in context: Context) -> FavoriteEntry {
        FavoriteEntry(date: Date(), product: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FavoriteEntry) -> Void) {
        let entry = FavoriteEntry(date: Date(), product: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FavoriteEntry>) -> Void) {
        Task {
            var entries: [FavoriteEntry] = []
            let favoriteProducts = await loadFavoriteProducts()
            
            let currentDate = Date()
            
            guard !favoriteProducts.isEmpty else {
                let entry = FavoriteEntry(date: currentDate, product: nil)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                return
            }
            
            for secondOffset in stride(from: 0, to: 600, by: 10) {
                let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
                let productIndex = (secondOffset / 10) % favoriteProducts.count
                let product = favoriteProducts[productIndex]
                let entry = FavoriteEntry(date: entryDate, product: product)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func loadFavoriteProducts() async -> [Product] {
        return await withCheckedContinuation { continuation in
            if let data = UserDefaults(suiteName: "group.LoboShop")?.data(forKey: "favoriteProducts"),
               let products = try? JSONDecoder().decode([Product].self, from: data) {
                continuation.resume(returning: products)
            } else {
                continuation.resume(returning: [])
            }
        }
    }
}

struct FavoritesWidgetEntryView: View {
    var entry: FavoriteEntry
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if let product = entry.product {
                HStack(alignment: .center) {
                    Image("LoboschopLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    
                        .overlay(Rectangle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                        .opacity(0.8)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(3)
                            .truncationMode(.tail)
                        
                        Text("\(product.price, specifier: "%.2f") €")
                            .font(.headline)
                            .foregroundColor(.purple.opacity(0.8))
                        
                        Text(product.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            } else {
                Image("LoboschopLogo")
                    .resizable()
                    .scaledToFit()
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.customBackgroundColor1, .customBackgroundColor2]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.purple.opacity(0.5), lineWidth: 3)
        )
        .padding(5)
    }
}

@main
struct FavoritesWidget: Widget {
    let kind: String = "FavoritesWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FavoritesProvider()) { entry in
            FavoritesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Favorite Products")
        .description("Automatically scrolls through your favorite products.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
