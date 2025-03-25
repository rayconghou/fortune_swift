//
//  SpotView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//  Updated for full market view and futuristic UI
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case rank = "Rank"
    case marketCap = "Market Cap"
}

struct SpotView: View {
    @Binding var hideHamburger: Bool
    @State private var scrollOffset: CGFloat = 0
    @State private var showBuyModal = false
    @State private var showSellModal = false
    @State private var searchText = ""
    
    @StateObject var marketVM = CryptoMarketViewModel()
    @State private var sortOption: SortOption = .rank

    // Sorted and filtered coins based on selected option and search text
    var filteredCoins: [Coin] {
        let sorted = switch sortOption {
        case .rank:
            marketVM.coins.sorted { ($0.market_cap_rank ?? 9999) < ($1.market_cap_rank ?? 9999) }
        case .marketCap:
            marketVM.coins.sorted { ($0.market_cap ?? 0) > ($1.market_cap ?? 0) }
        }
        
        if searchText.isEmpty {
            return sorted
        } else {
            return sorted.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search coins", text: $searchText)
                        .foregroundColor(.white)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(action: {
                        // TODO: Maneki can provide info
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 4)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.clear)
                .cornerRadius(10)
                .padding(.top, -40)
                
                // List of coins in a scrollable view
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCoins) { coin in
                            CryptoTrendCard(
                                rank: coin.market_cap_rank ?? 0,
                                name: coin.name,
                                symbol: coin.symbol,
                                imageUrl: coin.image,
                                price: coin.current_price,
                                change: coin.price_change_percentage_24h ?? 0,
                                sparkline: coin.sparkline_in_7d?.price.last24Hours ?? coin.sparkline_in_7d?.price ?? []
                            )
                        }
                    }
                    .padding()
                }
                .background(Color.black)
                
                // Floating BUY & SELL buttons
                HStack(spacing: 20) {
                    Button(action: { showBuyModal = true }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("BUY")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    
                    Button(action: { showSellModal = true }) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("SELL")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .sheet(isPresented: $showBuyModal) {
                    BuyCryptoView()
                }
                .sheet(isPresented: $showSellModal) {
                    SellCryptoView()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Spot")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // TODO: implement global notification system
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// Helper extension to extract the last 24 hours worth of sparkline data.
// Assumes the sparkline contains at least 24 points; otherwise returns the full array.
extension Array where Element == Double {
    var last24Hours: [Double] {
        if self.count >= 24 {
            return Array(self.suffix(24))
        } else {
            return self
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Preview (make sure to bind hideHamburger to a constant for previewing)
struct SpotView_Previews: PreviewProvider {
    @State static var hideHamburger = false
    static var previews: some View {
        SpotView(hideHamburger: $hideHamburger)
            .preferredColorScheme(.dark)
    }
}
