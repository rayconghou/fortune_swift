//
//  TrendingCoinsViewModel.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Model Structures for the Trending Endpoint
struct TrendingResponse: Codable {
    let coins: [TrendingCoinData]
}

struct TrendingCoinData: Codable {
    let item: TrendingCoin
}

struct TrendingCoin: Codable, Identifiable {
//    let id: String
    let coin_id: Int
    let name: String
    let symbol: String
    let thumb: String   // small thumbnail URL
    let small: String   // smaller image URL
    let large: String   // larger image URL
    let slug: String
    let price_btc: Double
    let score: Int
    
    // Identifiable requirement
    var identifier: String { id }
    
    // For SwiftUI ForEach, we can designate our `id` property like:
    var id: String { "\(coin_id)" }
}

struct TrendingCoinRow: View {
    let coin: TrendingCoin
    
    var body: some View {
        HStack(spacing: 12) {
            // Coin Thumbnail
            AsyncImage(url: URL(string: coin.thumb)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    // fallback image
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 24, height: 24)
            .clipShape(Circle())
            
            // Coin Name & Symbol
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(coin.symbol.uppercased())
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Score or rank-like metric if desired
            Text("#\(coin.score + 1)") // Score is zero-based, so +1 to show a typical rank
                .font(.footnote)
                .foregroundColor(.white)
            
            // If you want to show price in BTC or something else:
            Text("\(coin.price_btc, specifier: "%.8f") BTC")
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color(white: 0.1))
        .cornerRadius(8)
    }
}


// MARK: - TrendingCoinsViewModel
class TrendingCoinsViewModel: ObservableObject {
    @Published var trendingCoins: [TrendingCoin] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTrendingCoins()
    }
    
    func fetchTrendingCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/search/trending") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> TrendingResponse in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return try JSONDecoder().decode(TrendingResponse.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching trending coins:", error)
                }
            }, receiveValue: { [weak self] response in
                self?.trendingCoins = response.coins.map { $0.item }
            })
            .store(in: &cancellables)
    }
}
