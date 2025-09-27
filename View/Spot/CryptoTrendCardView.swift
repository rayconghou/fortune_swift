//
//  CryptoTrendCardView.swift
//  Dojo
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

// Function to get background color for crypto symbol
func backgroundColorForSymbol(_ symbol: String) -> Color {
    let lowercasedSymbol = symbol.lowercased()
    
    switch lowercasedSymbol {
    case "btc", "bitcoin":
        return Color(red: 1.0, green: 0.58, blue: 0.0) // Bitcoin orange
    case "eth", "ethereum":
        return Color(red: 0.46, green: 0.48, blue: 0.9) // Ethereum blue
    case "bnb", "binance":
        return Color(red: 0.8, green: 0.6, blue: 0.0) // Binance darker yellow
    case "sol", "solana":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Solana black
    case "ada", "cardano":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Cardano black
    case "xrp", "ripple":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Ripple black
    case "doge", "dogecoin":
        return Color(red: 0.8, green: 0.6, blue: 0.0) // Dogecoin darker yellow
    case "matic", "polygon":
        return Color(red: 0.6, green: 0.4, blue: 0.9) // Polygon purple
    case "avax", "avalanche":
        return Color(red: 0.9, green: 0.3, blue: 0.3) // Avalanche red
    case "dot", "polkadot":
        return Color(red: 0.9, green: 0.4, blue: 0.6) // Polkadot pink
    case "link", "chainlink":
        return Color(red: 0.2, green: 0.5, blue: 0.9) // Chainlink blue
    case "ltc", "litecoin":
        return Color(red: 0.7, green: 0.7, blue: 0.7) // Litecoin silver
    case "bch", "bitcoin-cash":
        return Color(red: 0.0, green: 0.8, blue: 0.0) // Bitcoin Cash green
    case "xlm", "stellar":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Stellar blue
    case "atom", "cosmos":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Cosmos black
    case "near":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // NEAR black
    case "ftm", "fantom":
        return Color(red: 0.2, green: 0.0, blue: 0.8) // Fantom blue
    case "algo", "algorand":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Algorand black
    case "vet", "vechain":
        return Color(red: 0.0, green: 0.6, blue: 0.4) // VeChain teal
    case "icp", "internet-computer":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Internet Computer black
    case "trx", "tron":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // TRON black
    case "usdt", "tether":
        return Color(red: 0.0, green: 0.4, blue: 0.2) // Tether forest green
    case "usde", "ethena":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Ethena USDE black
    case "wbeth", "wrapped-beth":
        return Color(red: 1.0, green: 0.84, blue: 0.0) // Wrapped BETH golden yellow
    case "wbtc", "wrapped-bitcoin":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Wrapped Bitcoin black
    case "usdc", "usd-coin":
        return Color(red: 0.2, green: 0.4, blue: 0.9) // USDC blue
    case "tao", "bittensor":
        return Color(red: 1.0, green: 1.0, blue: 1.0) // Bittensor white
    case "story":
        return Color(red: 1.0, green: 0.84, blue: 0.0) // Story gold
    case "jitosol", "jito-staked-sol":
        return Color(red: 1.0, green: 1.0, blue: 1.0) // Jito Staked SOL white
    case "apt", "aptos":
        return Color(red: 1.0, green: 1.0, blue: 1.0) // Aptos white
    case "steth", "lido-staked-ether":
        return Color(red: 1.0, green: 1.0, blue: 1.0) // Lido Staked Ether white
    case "fil", "filecoin":
        return Color(red: 0.2, green: 0.4, blue: 0.8) // Filecoin blue
    case "hbar", "hedera":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Hedera black
    case "mana", "decentraland":
        return Color(red: 0.8, green: 0.4, blue: 0.8) // Decentraland purple
    case "sand", "sandbox":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Sandbox blue
    case "axs", "axie-infinity":
        return Color(red: 0.0, green: 0.4, blue: 0.8) // Axie Infinity blue
    case "chz", "chiliz":
        return Color(red: 0.8, green: 0.0, blue: 0.0) // Chiliz red
    case "enj", "enjin":
        return Color(red: 0.4, green: 0.0, blue: 0.8) // Enjin purple
    case "gala":
        return Color(red: 0.0, green: 0.8, blue: 0.4) // Gala green
    case "flow":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Flow blue
    case "theta":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Theta black
    case "egld", "elrond":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Elrond black
    case "xtz", "tezos":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Tezos blue
    case "klay", "klaytn":
        return Color(red: 0.0, green: 0.4, blue: 0.8) // Klaytn blue
    case "eos":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // EOS black
    case "aave":
        return Color(red: 0.8, green: 0.0, blue: 0.4) // Aave pink
    case "comp", "compound":
        return Color(red: 0.0, green: 0.6, blue: 0.4) // Compound green
    case "mkr", "maker":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Maker black
    case "snx", "synthetix":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Synthetix black
    case "yfi", "yearn":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Yearn blue
    case "uni", "uniswap":
        return Color(red: 0.8, green: 0.0, blue: 0.4) // Uniswap pink
    case "sushi", "sushiswap":
        return Color(red: 0.8, green: 0.0, blue: 0.0) // SushiSwap red
    case "crv", "curve":
        return Color(red: 0.0, green: 0.8, blue: 0.0) // Curve green
    case "1inch":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // 1inch black
    case "bal", "balancer":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Balancer black
    case "lrc", "loopring":
        return Color(red: 0.0, green: 0.4, blue: 0.8) // Loopring blue
    case "zrx", "0x":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // 0x black
    case "bat", "basic-attention-token":
        return Color(red: 0.8, green: 0.4, blue: 0.0) // BAT orange
    case "zec", "zcash":
        return Color(red: 0.0, green: 0.6, blue: 0.4) // Zcash teal
    case "dash":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Dash blue
    case "xmr", "monero":
        return Color(red: 1.0, green: 0.4, blue: 0.0) // Monero orange
    case "etc", "ethereum-classic":
        return Color(red: 0.0, green: 0.6, blue: 0.4) // Ethereum Classic green
    case "neo":
        return Color(red: 0.0, green: 0.8, blue: 0.0) // NEO green
    case "qtum":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Qtum black
    case "waves":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Waves blue
    case "omg", "omg-network":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // OMG black
    case "zil", "zilliqa":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Zilliqa blue
    case "ont", "ontology":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Ontology black
    case "iost":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // IOST black
    case "nano":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Nano blue
    case "dgb", "digibyte":
        return Color(red: 0.0, green: 0.6, blue: 0.4) // DigiByte teal
    case "sc", "siacoin":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Siacoin black
    case "dcr", "decred":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Decred blue
    case "zcn", "0chain":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // 0chain black
    case "rvn", "ravencoin":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Ravencoin black
    case "beam":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Beam blue
    case "grin":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Grin black
    case "xvg", "verge":
        return Color(red: 0.0, green: 0.0, blue: 0.0) // Verge black
    case "btg", "bitcoin-gold":
        return Color(red: 1.0, green: 0.8, blue: 0.0) // Bitcoin Gold yellow
    case "bcd", "bitcoin-diamond":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Bitcoin Diamond blue
    case "bch", "bitcoin-cash-abc":
        return Color(red: 0.0, green: 0.8, blue: 0.0) // Bitcoin Cash ABC green
    case "bsv", "bitcoin-sv":
        return Color(red: 0.0, green: 0.6, blue: 0.8) // Bitcoin SV blue
    case "bch", "bitcoin-cash-sv":
        return Color(red: 0.0, green: 0.8, blue: 0.0) // Bitcoin Cash SV green
    default:
        // Generate a consistent color based on the symbol's hash
        let hash = symbol.hashValue
        let colors: [Color] = [
            Color(red: 0.2, green: 0.5, blue: 1.0),      // Blue
            Color(red: 0.0, green: 0.8, blue: 0.4),       // Green
            Color(red: 1.0, green: 0.4, blue: 0.0),       // Orange
            Color(red: 0.8, green: 0.0, blue: 0.4),       // Pink
            Color(red: 0.6, green: 0.4, blue: 0.9),       // Purple
            Color(red: 0.0, green: 0.6, blue: 0.8),       // Cyan
            Color(red: 0.9, green: 0.3, blue: 0.3),       // Red
            Color(red: 1.0, green: 0.8, blue: 0.0),       // Yellow
        ]
        return colors[abs(hash) % colors.count]
    }
}

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
            // Halo glow effect that extends all the way down
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            (change >= 0 ? Color.green : Color.red).opacity(0.15),
                            (change >= 0 ? Color.green : Color.red).opacity(0.05),
                            (change >= 0 ? Color.green : Color.red).opacity(0.02),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .blur(radius: 8)
                .offset(y: 4)
            
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
                            .font(.custom("Satoshi-Black", size: 14))
                            .foregroundColor(.gray)
                        
                        // Async coin image with consistent rounded square format
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 32, height: 32)
                        }
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(backgroundColorForSymbol(symbol))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(.custom("Satoshi-Black", size: 16))
                                .foregroundColor(.white)
                            Text(symbol.uppercased())
                                .font(.custom("Satoshi-Black", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // Right side: Price and Change
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(price.asFormattedCurrency)
                            .font(.custom("Satoshi-Black", size: 16))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            // Triangle indicator instead of arrow
                            Image(systemName: change >= 0 ? "triangle.fill" : "triangle.fill")
                                .resizable()
                                .foregroundColor(change >= 0 ? .green : .red)
                                .frame(width: 8, height: 8)
                                .rotationEffect(.degrees(change >= 0 ? 0 : 180))
                            
                            Text(String(format: "%.2f%%", abs(change)))
                                .font(.custom("Satoshi-Black", size: 14))
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
                
                // Create extrapolated data points to ensure full width coverage
                let extrapolatedData = createExtrapolatedData(normalizedData, targetCount: Int(geometry.size.width / 2))
                let step = geometry.size.width / CGFloat(extrapolatedData.count - 1)
                
                ZStack {
                    // Glowing effect (gradient fill below the line)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: 0, y: geometry.size.height * (1 - extrapolatedData.first!)))
                        
                        for i in extrapolatedData.indices {
                            let x = CGFloat(i) * step
                            let y = geometry.size.height * (1 - extrapolatedData[i])
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
                        path.move(to: CGPoint(x: 0, y: geometry.size.height * (1 - extrapolatedData.first!)))
                        for i in extrapolatedData.indices {
                            let x = CGFloat(i) * step
                            let y = geometry.size.height * (1 - extrapolatedData[i])
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
    
    // Function to create extrapolated data points for smoother, full-width charts
    private func createExtrapolatedData(_ data: [Double], targetCount: Int) -> [Double] {
        guard data.count > 1 else { return data }
        
        // If we already have enough points, return the original data
        if data.count >= targetCount {
            return data
        }
        
        var extrapolatedData: [Double] = []
        
        // Add extrapolated points at the beginning
        let firstValue = data.first!
        let secondValue = data[1]
        let startSlope = secondValue - firstValue
        
        // Add 2-3 points before the first data point
        let startPoints = min(3, targetCount / 4)
        for i in 0..<startPoints {
            let extrapolatedValue = firstValue - startSlope * Double(startPoints - i) * 0.3
            extrapolatedData.append(max(0, min(1, extrapolatedValue))) // Clamp between 0 and 1
        }
        
        // Add the original data points
        extrapolatedData.append(contentsOf: data)
        
        // Add extrapolated points at the end
        let lastValue = data.last!
        let secondLastValue = data[data.count - 2]
        let endSlope = lastValue - secondLastValue
        
        // Add 2-3 points after the last data point
        let endPoints = min(3, targetCount / 4)
        for i in 1...endPoints {
            let extrapolatedValue = lastValue + endSlope * Double(i) * 0.3
            extrapolatedData.append(max(0, min(1, extrapolatedValue))) // Clamp between 0 and 1
        }
        
        // If we still need more points, interpolate between existing points
        if extrapolatedData.count < targetCount {
            let additionalPoints = targetCount - extrapolatedData.count
            let step = Double(extrapolatedData.count - 1) / Double(additionalPoints + 1)
            
            var finalData: [Double] = []
            var currentIndex = 0.0
            
            for i in 0..<targetCount {
                if currentIndex >= Double(extrapolatedData.count - 1) {
                    finalData.append(extrapolatedData.last!)
                } else {
                    let lowerIndex = Int(currentIndex)
                    let upperIndex = min(lowerIndex + 1, extrapolatedData.count - 1)
                    let fraction = currentIndex - Double(lowerIndex)
                    
                    let interpolatedValue = extrapolatedData[lowerIndex] + 
                        (extrapolatedData[upperIndex] - extrapolatedData[lowerIndex]) * fraction
                    finalData.append(interpolatedValue)
                }
                currentIndex += step
            }
            
            return finalData
        }
        
        return extrapolatedData
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
