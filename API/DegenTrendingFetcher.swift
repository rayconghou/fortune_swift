//
//  DegenTrendingFetcher.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import Combine

/// Decodable model for DexScreener "Trending" or "Moonshot" pairs
struct TokenPair: Codable, Identifiable {
    let id = UUID()
    let chainId: String
    let dexId: String
    let pairAddress: String
    let baseToken: BaseToken
    let quoteToken: QuoteToken
    let priceUsd: String?
    let fdv: Double?
    let liquidity: Liquidity?
    let volume: Volume?   // We'll parse 24h volume if provided
    let marketCap: Double?

    struct BaseToken: Codable {
        let address: String
        let name: String
        let symbol: String
    }

    struct QuoteToken: Codable {
        let symbol: String
        // If you need the quote token name, you can add it here
    }

    struct Liquidity: Codable {
        let usd: Double?
    }

    // We'll store 24h volume under volume?.h24 if DexScreener includes it
    struct Volume: Codable {
        let h24: Double?

        enum CodingKeys: String, CodingKey {
            case h24 = "24h"
        }
    }
}

/// Root decodable for DexScreener to parse `pairs: [...]`
struct TrendingResponse: Codable {
    let pairs: [TokenPair]
}

/// Fetcher class to retrieve DexScreener trending pairs
class DegenPairsFetcher: ObservableObject {
    @Published var latestPairs: [TokenPair] = []
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var fetchTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()

    init() {
        fetchTrendingPairs()

        // Auto-refresh every 15 seconds
        fetchTimer
            .sink { [weak self] _ in
                self?.fetchTrendingPairs()
            }
            .store(in: &cancellables)
    }

    /// Call DexScreener endpoint for trending pairs (example: "moonshots" endpoint)
    func fetchTrendingPairs() {
        // If DexScreener provides a special endpoint for "moonshots" or "trending" tokens:
        guard let url = URL(string: "https://api.dexscreener.com//token-profiles/latest/v1") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> TrendingResponse in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return try JSONDecoder().decode(TrendingResponse.self, from: result.data)
            }
            .map { $0.pairs }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { pairs in
                self.latestPairs = pairs
            })
            .store(in: &cancellables)
    }
}
