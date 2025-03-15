//
//  PortfolioView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct PortfolioView: View {
    @State private var selectedTimeframe: Timeframe = .week
    @StateObject private var viewModel = PortfolioViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Main balance card
                    VStack(spacing: 10) {
                        HStack {
                            Text("Total Balance")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        Text("$\(viewModel.totalBalance, specifier: "%.2f")")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: viewModel.totalChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                .foregroundColor(viewModel.totalChange >= 0 ? .green : .red)
                            Text("\(viewModel.totalChange >= 0 ? "+" : "")\(viewModel.totalChangeValue, specifier: "$%.2f")")
                                .foregroundColor(viewModel.totalChange >= 0 ? .green : .red)
                            Text("(\(viewModel.totalChange, specifier: "%.2f")%)")
                                .foregroundColor(.gray)
                        }
                        .font(.subheadline)
                        
                        // P&L Timeframe Selector
                        HStack(spacing: 0) {
                            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                                Button(action: {
                                    selectedTimeframe = timeframe
                                    viewModel.updatePnL(for: timeframe)
                                }) {
                                    Text(timeframe.rawValue)
                                        .font(.subheadline)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(selectedTimeframe == timeframe ? .white : .gray)
                                        .background(selectedTimeframe == timeframe ? Color(UIColor.systemGray5) : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        // P&L Metrics
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Unrealized P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.unrealizedPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.unrealizedPnL >= 0 ? .green : .red)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Realized P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.realizedPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.realizedPnL >= 0 ? .green : .red)
                                }
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Total P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.totalPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.totalPnL >= 0 ? .green : .white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("% Change")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.totalPnLPercentage >= 0 ? "+" : "")\(viewModel.totalPnLPercentage, specifier: "%.2f")%")
                                        .font(.headline)
                                        .foregroundColor(viewModel.totalPnLPercentage >= 0 ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Asset section header
                    HStack {
                        Text("Your Assets")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if viewModel.portfolioAssets.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "briefcase")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                            Text("No Assets Yet")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Start your crypto journey by purchasing your first coin.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 40)
                            Button(action: {
                                // Navigate to buy screen if needed
                            }) {
                                Text("Buy Crypto")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.vertical, 50)
                    } else {
                        ForEach(viewModel.portfolioAssets) { asset in
                            AssetRow(asset: asset)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 6) {
                        Text("Portfolio")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // TODO: implement notification system
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

// MARK: - Models

class PortfolioViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var portfolioAssets: [PortfolioAsset] = []
    @Published var totalBalance: Double = 0.0
    @Published var totalChange: Double = 0.0
    @Published var totalChangeValue: Double = 0.0
    @Published var unrealizedPnL: Double = 0.0
    @Published var realizedPnL: Double = 0.0
    @Published var totalPnL: Double = 0.0
    @Published var totalPnLPercentage: Double = 0.0
    
    // Sample portfolio holdings - in a real app, this would come from user data
    private let holdings = [
        AssetHolding(id: "bitcoin", amount: 0.5),
        AssetHolding(id: "ethereum", amount: 2.5),
        AssetHolding(id: "solana", amount: 25.0),
        AssetHolding(id: "cardano", amount: 1000.0)
    ]
    
    func fetchData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching market data:", error)
                return
            }
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode([Coin].self, from: data)
                DispatchQueue.main.async {
                    self.coins = decoded
                    self.createPortfolioAssets()
                    self.calculateTotals()
                    self.updatePnL(for: .week)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
    
    func refreshData() {
        fetchData()
    }
    
    private func createPortfolioAssets() {
        portfolioAssets = []
        
        for holding in holdings {
            if let coin = coins.first(where: { $0.id == holding.id }) {
                let totalValue = coin.current_price * holding.amount
                let asset = PortfolioAsset(
                    id: coin.id,
                    name: coin.name,
                    symbol: coin.symbol,
                    amount: holding.amount,
                    currentPrice: coin.current_price,
                    totalValue: totalValue,
                    priceChangePercentage: coin.price_change_percentage_24h ?? 0,
                    imageUrl: coin.image
                )
                portfolioAssets.append(asset)
            }
        }
    }
    
    private func calculateTotals() {
        totalBalance = portfolioAssets.reduce(0) { $0 + $1.totalValue }
        
        // Calculate overall change based on 24h percentage
        let weightedChange = portfolioAssets.reduce(0.0) {
            $0 + ($1.priceChangePercentage * ($1.totalValue / max(1, totalBalance)))
        }
        totalChange = weightedChange
        totalChangeValue = totalBalance * (totalChange / 100)
    }
    
    func updatePnL(for timeframe: Timeframe) {
        // In a real app, this would use historical data for the selected timeframe
        // For this demo, we'll use simulated values based on the timeframe
        switch timeframe {
        case .day:
            unrealizedPnL = totalBalance * 0.02
            realizedPnL = totalBalance * -0.005
        case .week:
            unrealizedPnL = totalBalance * 0.045
            realizedPnL = totalBalance * -0.003
        case .month:
            unrealizedPnL = totalBalance * 0.12
            realizedPnL = totalBalance * 0.01
        case .year:
            unrealizedPnL = totalBalance * 0.35
            realizedPnL = totalBalance * 0.05
        case .all:
            unrealizedPnL = totalBalance * 0.65
            realizedPnL = totalBalance * 0.15
        }
        
        totalPnL = unrealizedPnL + realizedPnL
        totalPnLPercentage = (totalPnL / totalBalance) * 100
    }
}



enum Timeframe: String, CaseIterable {
    case day = "24h"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .preferredColorScheme(.dark)
    }
}
