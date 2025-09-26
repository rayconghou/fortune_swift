//
//  CryptoTrendCardView.swift
//  Dojo
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct CryptoTrendCard: View {
    let rank: Int
    let name: String
    let symbol: String
    let imageUrl: String
    let price: Double
    /// This is the 24h change in percent (e.g. -3.12 means -3.12%)
    let change: Double
    /// Array of price points (ideally last 24 hours)
    let sparkline: [Double]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "141628")
                .cornerRadius(15)
            
            VStack(spacing: 0) {
                // Top section: Coin info and price
                HStack(spacing: 12) {
                    // Left side: Rank, Logo, Name/Symbol
                    HStack(spacing: 12) {
                        // Ranking
                        Text("#\(rank)")
                            .font(.custom("Satoshi-Bold", size: 14))
                            .foregroundColor(.gray)
                        
                        // Async coin image - Square shape like in the image
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.custom("Satoshi-Bold", size: 16))
                                .foregroundColor(.white)
                            Text(symbol.uppercased())
                                .font(.custom("Satoshi-Bold", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Right side: Price and Change
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(price.asFormattedCurrency)
                            .font(.custom("Satoshi-Bold", size: 16))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            // Triangle indicator instead of arrow
                            Image(systemName: change >= 0 ? "triangle.fill" : "triangle.fill")
                                .resizable()
                                .foregroundColor(change >= 0 ? .green : .red)
                                .frame(width: 8, height: 8)
                                .rotationEffect(.degrees(change >= 0 ? 0 : 180))
                            
                            Text(String(format: "%.2f%%", abs(change)))
                                .font(.custom("Satoshi-Bold", size: 14))
                                .foregroundColor(change >= 0 ? .green : .red)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                .padding(.bottom, 10)
                
                // Bottom section: Full-width sparkline chart
                SparklineChartView(data: sparkline, isPositive: change >= 0)
                    .frame(height: 50)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
            }
        }
        .frame(height: 123) // Updated to match Figma specifications
    }
}

// A simple sparkline chart that scales the data to the view's height
struct SparklineChartView: View {
    let data: [Double]
    let isPositive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if let minValue = data.min(), let maxValue = data.max(), minValue != maxValue {
                let normalizedData = data.map { ($0 - minValue) / (maxValue - minValue) }
                let step = geometry.size.width / CGFloat(data.count - 1)
                
                ZStack {
                    // Glowing effect (gradient fill below the line)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: 0, y: geometry.size.height * (1 - normalizedData.first!)))
                        
                        for i in data.indices {
                            let x = CGFloat(i) * step
                            let y = geometry.size.height * (1 - normalizedData[i])
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        
                        path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                (isPositive ? Color.green : Color.red).opacity(0.3),
                                (isPositive ? Color.green : Color.red).opacity(0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Main chart line
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height * (1 - normalizedData.first!)))
                        for i in data.indices {
                            let x = CGFloat(i) * step
                            let y = geometry.size.height * (1 - normalizedData[i])
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    .stroke(isPositive ? Color.green : Color.red, lineWidth: 1.5)
                    .opacity(0.9)
                }
            } else {
                // Fallback flat line if data is constant or empty
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke(isPositive ? Color.green : Color.red, lineWidth: 1.5)
                .opacity(0.8)
            }
        }
    }
}

// Currency formatter extension for Double
extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    var asFormattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        // Add spaces for thousands separator like in the image
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "$0.00"
        return formatted.replacingOccurrences(of: ",", with: " ")
    }
}

struct CryptoTrendCard_Previews: PreviewProvider {
    static var previews: some View {
        CryptoTrendCard(
            rank: 1,
            name: "Bitcoin",
            symbol: "btc",
            imageUrl: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            price: 117176.16,
            change: 1.12,
            sparkline: [100, 102, 98, 105, 110, 108, 115, 112, 120, 118, 125, 122, 130, 128, 135, 132, 140, 138, 145, 142, 150, 148, 155, 152]
        )
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
