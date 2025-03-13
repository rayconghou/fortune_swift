//
//  SharedUI.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/13/25.
//

import Foundation
import SwiftUI

// MARK: - Support Views

struct CryptoTrendCard: View {
    let name: String
    let symbol: String
    let price: Double
    /// This is the 24h change in percent (e.g. -3.12 means -3.12%)
    let change: Double
    
    var body: some View {
        // Decide if it’s positive or negative
        let isPositive = change >= 0
        // Format the numeric change to a percentage string
        let changeString = String(format: "%.2f%%", change)
        
        HStack {
            // Left section: Crypto logo + name + symbol
            Image(symbol.uppercased())  // Uses BTC, ETH, SOL image names
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .clipShape(Circle()) // Ensures a round shape for consistency
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            // Right section: price + 24h change with icon
            VStack(alignment: .trailing) {
                // Current price formatted as currency:
                Text(price.asCurrency)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    // Icon: arrow up or down
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .resizable()
                        .foregroundColor(isPositive ? .green : .red)
                        .frame(width: 10, height: 10)
                    
                    // The text “+1.23%” or “-2.34%”
                    Text(changeString)
                        .font(.subheadline)
                        .foregroundColor(isPositive ? .green : .red)
                        .padding(.leading, 5)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NewsCard: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct IndexCard: View {
    let name: String
    let value: String
    let change: String
    
    var isPositive: Bool {
        return change.contains("+")
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .trailing) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(change)
                    .font(.subheadline)
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DegenTradingCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Action for trading option
            }) {
                Text("Start Trading")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(height: 90)
        .frame(minWidth: 300)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

