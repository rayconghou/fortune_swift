//
//  SpottingView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

// MARK: - SpottingView

struct SpottingView: View {
    // If you need the hamburger logic from your code:
    @Binding var hideHamburger: Bool
    
    // 1) Create a single ViewModel instance for prices
    @StateObject var priceVM = CryptoPriceViewModel()
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showBuyModal = false
    @State private var showSellModal = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: OffsetPreferenceKey.self,
                                    value: geo.frame(in: .global).minY)
                }
                .frame(height: 1)
                
                VStack(spacing: 16) {
                    Text("Market Prices")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 30)
                    
                    // 2) Replace static prices with live data from the ViewModel:
                    CryptoTrendCard(
                        name: "Bitcoin",
                        symbol: "BTC",
                        price: priceVM.btcPrice,
                        change: priceVM.btc24hChange
                    )
                    
                    CryptoTrendCard(
                        name: "Ethereum",
                        symbol: "ETH",
                        price: priceVM.ethPrice,
                        change: priceVM.eth24hChange
                    )
                    
                    CryptoTrendCard(
                        name: "Solana",
                        symbol: "SOL",
                        price: priceVM.solPrice,
                        change: priceVM.sol24hChange
                    )
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    // Market News, etc...
                    Text("Market News")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
//                        .padding(.top, 20)
                    
                    NewsCard(title: "Bitcoin Reaches New All-Time High", time: "2 hours ago")
                    NewsCard(title: "SEC Approves New Crypto ETF", time: "5 hours ago")
                    NewsCard(title: "Major Bank Adopts Blockchain Technology", time: "1 day ago")
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    // TODO: Market Overview
//                    Text("Market Overview")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.horizontal)
////                        .padding(.top, 20)
                    
                   // TODO: incorporate real-time tracking statistics of market cap, trading volume
                    
                    // Extra bottom padding for floating buttons
                    Spacer().frame(height: 75)
                }
                .padding(.horizontal)
            }
            .background(Color.black)
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            
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
        }
        .sheet(isPresented: $showBuyModal) {
            BuyCryptoView()
        }
        .sheet(isPresented: $showSellModal) {
            SellCryptoView()
        }
    }
}
