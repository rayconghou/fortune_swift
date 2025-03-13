//
//  CryptoTrendCardView.swift
//  FortuneCollective
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Ranking
                Text("#\(rank)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Async coin image
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(symbol.uppercased())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(price.asCurrency)
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack(spacing: 4) {
                        Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .resizable()
                            .foregroundColor(change >= 0 ? .green : .red)
                            .frame(width: 10, height: 10)
                        Text(String(format: "%.2f%%", change))
                            .font(.subheadline)
                            .foregroundColor(change >= 0 ? .green : .red)
                    }
                }
            }
            
            // Sparkline Chart (using only the last 24 hours worth of data)
            SparklineChartView(data: sparkline)
                .frame(height: 40)
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
    }
}

// A simple sparkline chart that scales the data to the view's height
struct SparklineChartView: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            if let minValue = data.min(), let maxValue = data.max(), minValue != maxValue {
                let normalizedData = data.map { ($0 - minValue) / (maxValue - minValue) }
                let step = geometry.size.width / CGFloat(data.count - 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * (1 - normalizedData.first!)))
                    for i in data.indices {
                        let x = CGFloat(i) * step
                        let y = geometry.size.height * (1 - normalizedData[i])
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            } else {
                // Fallback flat line if data is constant or empty
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke(Color.blue, lineWidth: 2)
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
}

struct CryptoTrendCard_Previews: PreviewProvider {
    static var previews: some View {
        CryptoTrendCard(
            rank: 1,
            name: "Bitcoin",
            symbol: "btc",
            imageUrl: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
            price: 22884.2,
            change: -2.79,
            sparkline: Array(repeating: 22000.0, count: 24)
        )
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
