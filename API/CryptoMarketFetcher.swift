//
//  CryptoMarketViewModel.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/13/25.
//  Updated to fetch the full coin list with sparkline data from CoinGecko
//

import Foundation
import Combine

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
}

struct SparklineData: Codable {
    let price: [Double]
}

// MARK: - CryptoMarketViewModel

class CryptoMarketViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    
    private var cancellables = Set<AnyCancellable>()
    // Update frequency set to 30 seconds (adjust as needed)
    private var fetchTimer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
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
}
