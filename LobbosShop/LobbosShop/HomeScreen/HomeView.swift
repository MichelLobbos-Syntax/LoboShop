import SwiftUI

struct HomeView: View {
    @State var searchText: String = ""
    @State var showSearchBar: Bool = false
    @State var showFilter: Bool = false
    @State var showButton: Bool = true
    @State private var scrollOffset: CGFloat = 0
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var ordersViewModel = OrdersViewModel(userViewModel: UserViewModel())
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                GradientBackgroundView()
                
                VStack(spacing: 8) {
                    if showSearchBar {
                        SearchBarView(text: $viewModel.searchText)
                            .padding(.horizontal)
                    }
                    
                    if showFilter {
                        PriceFilterView(selectedPrice: $viewModel.selectedPrice, sortOption: $viewModel.sortOption)
                            .padding()
                    }
                    
                    if showButton {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                FilterButtonView(title: "All", icon: "rectangle.grid.2x2", selectedCategory: $viewModel.selectedCategory, category: nil)
                                FilterButtonView(title: "Electronics", icon: "ipad", selectedCategory: $viewModel.selectedCategory, category: "electronics")
                                FilterButtonView(title: "Jewelery", icon: "sparkles", selectedCategory: $viewModel.selectedCategory, category: "jewelery")
                                FilterButtonView(title: "Men's Clothing", icon: "tshirt", selectedCategory: $viewModel.selectedCategory, category: "men's clothing")
                                FilterButtonView(title: "Women's Clothing", icon: "handbag", selectedCategory: $viewModel.selectedCategory, category: "women's clothing")
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .top))
                        }
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            ForEach(viewModel.filteredProducts.indices, id: \.self) { index in
                                NavigationLink(destination: DetailView(products: viewModel.filteredProducts, selectedIndex: index)) {
                                    ProductCardView(product: viewModel.filteredProducts[index])
                                        .environmentObject(ordersViewModel)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Image("LogoLoboShop")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .padding()
                        
                        
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                showSearchBar.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.white)
                        }
                        
                        Button(action: {
                            withAnimation {
                                showFilter.toggle()
                            }
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(Color.white)
                        }
                    }
                }
            }
        }
        .environmentObject(ordersViewModel)
        .onAppear {
            ordersViewModel.reloadOrders() // Bestellungen und Bewertungen laden, wenn die Ansicht angezeigt wird
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(HomeViewModel())
                .environmentObject(FavoritesViewModel())
                .environmentObject(CartViewModel())
                .environmentObject(OrdersViewModel(userViewModel: UserViewModel()))
                .environment(\.colorScheme, .light)
        }
    }
}
