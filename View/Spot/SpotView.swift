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
    var hamburgerAction: () -> Void
    @State private var selectedCoin: Coin? = nil
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
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.clear)
            .cornerRadius(10)
            
            // List of coins in a scrollable view
            ZStack {
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
                            .onTapGesture {
                                selectedCoin = coin
                            }
                        }
                    }
                    .padding()
                }
                
                // Floating BUY & SELL buttons
                VStack() {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        // BUY BUTTON
                        Button(action: { showBuyModal = true }) {
                            Text("Buy")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(hex: "0C0C0C")) // dark opaque
                                        .shadow(color: Color.white.opacity(0.08), radius: 10, x: 0, y: 6)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        }

                        // SELL BUTTON
                        Button(action: { showSellModal = true }) {
                            Text("Sell")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color(hex: "2C2C2C")) // lighter gray opaque
                                        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 6)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .sheet(isPresented: $showBuyModal) {
                        BuyCryptoView()
                    }
                    .sheet(isPresented: $showSellModal) {
                        SellCryptoView()
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(item: $selectedCoin) { coin in
            CoinDetailModalView(coin: coin, marketVM: marketVM)
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
        SpotView(hideHamburger: $hideHamburger, hamburgerAction: {})
            .preferredColorScheme(.dark)
    }
}
