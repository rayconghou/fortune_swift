//
//  DegenTrendingViewModel.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import Combine

class DegenTrendingViewModel: ObservableObject {
    @Published var latestTokens: [DexScreenerTokenProfile] = []
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchLatestTokens()
    }

    func fetchLatestTokens() {
        guard let url = URL(string: "https://api.dexscreener.com/token-profiles/latest/v1") else {
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> [DexScreenerTokenProfile] in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // If the endpoint returns an array of objects
                let decoder = JSONDecoder()
                return try decoder.decode([DexScreenerTokenProfile].self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching from DexScreener:", error.localizedDescription)
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] tokenProfiles in
                self?.latestTokens = tokenProfiles
            })
            .store(in: &cancellables)
    }
}

