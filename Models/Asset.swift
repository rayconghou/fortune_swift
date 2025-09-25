//
//  Asset.swift
//  Dojo
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct Asset: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let amount: Double
    let value: Double
    
    init(name: String, symbol: String, amount: Double, value: Double) {
        self.name = name
        self.symbol = symbol
        self.amount = amount
        self.value = value
    }
}

struct AssetRow: View {
    let asset: PortfolioAsset
    
    var body: some View {
        HStack(spacing: 16) {
            // Asset image from CoinGecko
            if let imageUrl = Optional(asset.imageUrl), !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 48, height: 48)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    case .failure:
                        // Fallback to letter icon if image fails to load
                        ZStack {
                            Circle()
                                .fill(Color(UIColor.systemGray5))
                                .frame(width: 48, height: 48)
                            
                            Text(asset.symbol.prefix(1).uppercased())
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    @unknown default:
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 48, height: 48)
                    }
                }
            } else {
                // Fallback letter icon when no image URL is available
                ZStack {
                    Circle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: 48, height: 48)
                    
                    Text(asset.symbol.prefix(1).uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            
            // Asset details
            VStack(alignment: .leading, spacing: 4) {
                Text(asset.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(asset.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Asset value
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(asset.totalValue, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 2) {
                    Image(systemName: asset.priceChangePercentage >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption2)
                    Text("\(abs(asset.priceChangePercentage), specifier: "%.2f")%")
                        .font(.subheadline)
                }
                .foregroundColor(asset.priceChangePercentage >= 0 ? .green : .red)
            }
        }
        .padding(16)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}


struct AssetHolding {
    let id: String
    let amount: Double
}


struct PortfolioAsset: Identifiable {
    let id: String
    let name: String
    let symbol: String
    let amount: Double
    let currentPrice: Double
    let totalValue: Double
    let priceChangePercentage: Double
    let imageUrl: String
}
