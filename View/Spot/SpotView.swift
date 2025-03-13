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
    
    @StateObject var marketVM = CryptoMarketViewModel()
    @State private var sortOption: SortOption = .rank

    // Sorted coins based on selected option.
    var sortedCoins: [Coin] {
        switch sortOption {
        case .rank:
            return marketVM.coins.sorted { ($0.market_cap_rank ?? 9999) < ($1.market_cap_rank ?? 9999) }
        case .marketCap:
            return marketVM.coins.sorted { ($0.market_cap ?? 0) > ($1.market_cap ?? 0) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Spot")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        // Open help or info as needed
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.top, 16)
                
//                // Sorting Picker
//                Picker("Sort by", selection: $sortOption) {
//                    ForEach(SortOption.allCases, id: \.self) { option in
//                        Text(option.rawValue)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)
                
                // List of coins in a scrollable view
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(sortedCoins) { coin in
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
                .padding(.top, -10)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
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
