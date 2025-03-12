//
//  CryptoPriceService.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import Combine

// MARK: - Real-Time Crypto Updates with CoinGecko API

class CryptoPriceViewModel: ObservableObject {
    @Published var btcPrice: Double = 0.0
    @Published var btc24hChange: Double = 0.0
    
    @Published var ethPrice: Double = 0.0
    @Published var eth24hChange: Double = 0.0
    
    @Published var solPrice: Double = 0.0
    @Published var sol24hChange: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    
    // Timer that automatically fires every 5 seconds (you can set to 10, etc):
    private var fetchTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init() {
        // Immediately fetch on init:
        fetchData()
        
        // Re-fetch whenever the timer fires:
        fetchTimer
            .sink { [weak self] _ in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    /// Fetches BTC, ETH, and SOL in USD (and their 24h changes)
    func fetchData() {
        guard let url = URL(string:
          "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd&include_24hr_change=true"
        ) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                return
            }
            guard let data = data else { return }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(dataString)")
            }
            
            do {
                // JSON shape with &include_24hr_change=true looks like:
                // {
                //   "bitcoin":  { "usd": 22884.2, "usd_24h_change": -2.79133 ... },
                //   "ethereum": { "usd": 1550.50, "usd_24h_change": 4.1234 ... },
                //   "solana":   { "usd": 25.12,   "usd_24h_change": 0.5432 ... }
                // }
                let decoded = try JSONDecoder().decode(CoingeckoSimplePrice.self, from: data)
                DispatchQueue.main.async {
                    // Check that each coin is present; if not, log an error and avoid updating the UI.
                    guard let bitcoin = decoded.bitcoin else {
                        print("Error: 'bitcoin' field is missing in the JSON response.")
                        return
                    }
                    guard let ethereum = decoded.ethereum else {
                        print("Error: 'ethereum' field is missing in the JSON response.")
                        return
                    }
                    guard let solana = decoded.solana else {
                        print("Error: 'solana' field is missing in the JSON response.")
                        return
                    }
                    
                    self.btcPrice       = bitcoin.usd
                    self.btc24hChange   = bitcoin.usd_24h_change
                    self.ethPrice       = ethereum.usd
                    self.eth24hChange   = ethereum.usd_24h_change
                    self.solPrice       = solana.usd
                    self.sol24hChange   = solana.usd_24h_change
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}
