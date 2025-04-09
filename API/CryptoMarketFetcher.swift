//
//  CryptoMarketViewModel.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/13/25.
//  Updated to fetch the full coin list with sparkline data from CoinGecko
//

import Foundation
import Combine
import SwiftUI

// MARK: - Coin Models

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double?
    let market_cap_rank: Int?
    let price_change_percentage_24h: Double?
    let sparkline_in_7d: SparklineData?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case current_price = "current_price"
        case market_cap = "market_cap"
        case market_cap_rank = "market_cap_rank"
        case price_change_percentage_24h = "price_change_percentage_24h"
        case sparkline_in_7d = "sparkline_in_7d"
    }
}

struct CoinDetail: Codable, Identifiable {
    let id: String
    let name: String
    let symbol: String
    let description: [String: String]
    let links: CoinLinks?
}

struct CoinLinks: Codable {
    let homepage: [String]?
}

struct CoinDetailModalView: View {
    let coin: Coin
    @ObservedObject var marketVM: CryptoMarketViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: coin.image)) { image in
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                }

                Text(coin.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text(coin.symbol.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Price: $\(coin.current_price, specifier: "%.2f")")
                    Text("Market Cap: $\(coin.market_cap ?? 0)")
                    Text("24h Change: \(coin.price_change_percentage_24h ?? 0, specifier: "%.2f")%")
                }
                .foregroundColor(.white)

                Divider()
                
                if let detail = marketVM.selectedCoinDetail {
                    if let desc = detail.description["en"], !desc.isEmpty {
                        Text(desc)
                            .font(.body)
                            .foregroundColor(.white)
                    } else {
                        Text("No description available.")
                            .foregroundColor(.gray)
                    }

                    if let homepage = detail.links?.homepage?.first, !homepage.isEmpty {
                        Link(destination: URL(string: homepage)!) {
                            Text("Visit Website")
                                .underline()
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 8)
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}


struct SparklineData: Codable {
    let price: [Double]
}

struct SparklineView: View {
    let data: [Double]

    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let height = geometry.size.height
            let width = geometry.size.width
            let step = width / CGFloat(max(data.count - 1, 1))

            Path { path in
                for index in data.indices {
                    let x = CGFloat(index) * step
                    let normalized = (data[index] - minValue) / (maxValue - minValue)
                    let y = height * (1 - CGFloat(normalized))

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.blue]),
                startPoint: .leading,
                endPoint: .trailing
            ), lineWidth: 2)
        }
    }
}


// MARK: - CryptoMarketViewModel

class CryptoMarketViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var fetchTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @Published var selectedCoinDetail: CoinDetail?
    
    init() {
        fetchData()
        fetchTimer
            .sink { [weak self] _ in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true") else {
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
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
    
    func fetchCoinDetail(id: String) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)")!
            
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(CoinDetail.self, from: data) {
                    DispatchQueue.main.async {
                        self.selectedCoinDetail = decoded
                    }
                }
            }
        }.resume()
    }
}
