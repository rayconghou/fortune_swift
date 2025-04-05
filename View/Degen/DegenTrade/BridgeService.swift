//
//  BridgeService.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import Combine

// MARK: - Li.Fi Models

struct LiFiQuoteRequest: Codable {
    let fromChain: String
    let toChain: String
    let fromToken: String
    let toToken: String
    let fromAmount: String
    let fromAddress: String
    let slippage: Double
}

struct LiFiQuoteResponse: Codable {
    let id: String
    let type: String
    let tool: String
    let action: ActionDetails
    let estimate: EstimateDetails
    let includedSteps: [StepDetails]
    let transactionRequest: TransactionRequest
}

struct ActionDetails: Codable {
    let fromChainId: String
    let toChainId: String
    let fromToken: TokenDetails
    let toToken: TokenDetails
    let fromAmount: String
    let slippage: Double
    let fromAddress: String
}

struct TokenDetails: Codable {
    let address: String
    let symbol: String
    let decimals: Int
    let chainId: String
    let name: String
    let coinKey: String?
    let logoURI: String?
}

struct EstimateDetails: Codable {
    let fromAmount: String
    let toAmount: String
    let toAmountMin: String
    let approvalAddress: String
    let feeCosts: [FeeCost]?
    let gasCosts: [GasCost]?
    let executionDuration: Int
    let fromAmountUSD: String?
    let toAmountUSD: String?
}

struct FeeCost: Codable {
    let name: String
    let percentage: String
    let token: TokenDetails
    let amount: String
    let amountUSD: String?
}

struct GasCost: Codable {
    let type: String
    let price: String
    let estimate: String
    let limit: String
    let amount: String
    let amountUSD: String?
    let token: TokenDetails
}

struct StepDetails: Codable {
    let id: String
    let type: String
    let tool: String
    let action: ActionDetails
    let estimate: EstimateDetails
}

struct TransactionRequest: Codable {
    let data: String
    let to: String
    let value: String
    let from: String
    let chainId: String
}

// MARK: - Li.Fi Bridge Service

class LiFiBridgeService {
    private let baseURL = "https://li.fi/api/v1"
    private let apiKey = "YOUR_LIFI_API_KEY" // You'll need to get this from Li.Fi
    
    func getQuote(fromChain: Chain, toChain: Chain, amount: String, walletAddress: String) async throws -> LiFiQuoteResponse {
        // Convert chain identifiers to Li.Fi chain IDs
        let fromChainId = getChainId(for: fromChain)
        let toChainId = getChainId(for: toChain)
        
        // Define native tokens for each chain
        let fromToken = getNativeToken(for: fromChain)
        let toToken = getNativeToken(for: toChain)
        
        // Create the quote request
        let quoteRequest = LiFiQuoteRequest(
            fromChain: fromChainId,
            toChain: toChainId,
            fromToken: fromToken,
            toToken: toToken,
            fromAmount: convertToWei(amount: amount, for: fromChain),
            fromAddress: walletAddress,
            slippage: 0.5 // 0.5%
        )
        
        // Encode the request
        guard let requestData = try? JSONEncoder().encode(quoteRequest) else {
            throw NSError(domain: "LiFiBridgeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request"])
        }
        
        // Create the URL request
        guard let url = URL(string: "\(baseURL)/quote") else {
            throw NSError(domain: "LiFiBridgeService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "LiFiBridgeService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        // Decode the response
        do {
            let quoteResponse = try JSONDecoder().decode(LiFiQuoteResponse.self, from: data)
            return quoteResponse
        } catch {
            throw NSError(domain: "LiFiBridgeService", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response: \(error.localizedDescription)"])
        }
    }
    
    func executeTransaction(quote: LiFiQuoteResponse) async throws -> String {
        // In a production app, this would send the transaction to Li.Fi's execute endpoint
        // For now, we'll just return a mock transaction hash
        
        // Simulate network request
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        return "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    
    // Helper methods
    
    private func getChainId(for chain: Chain) -> String {
        switch chain {
        case .sol: return "solana"
        case .eth: return "eth"
        case .base: return "base"
        case .bsc: return "bsc"
        }
    }
    
    private func getNativeToken(for chain: Chain) -> String {
        switch chain {
        case .sol: return "SOL"
        case .eth: return "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" // ETH
        case .base: return "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" // ETH on Base
        case .bsc: return "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE" // BNB
        }
    }
    
    private func convertToWei(amount: String, for chain: Chain) -> String {
        guard let value = Double(amount) else { return "0" }
        
        let decimals: Int
        switch chain {
        case .sol: decimals = 9
        case .eth, .base: decimals = 18
        case .bsc: decimals = 18
        }
        
        let multiplier = pow(10, Double(decimals))
        let weiAmount = value * multiplier
        
        return String(format: "%.0f", weiAmount)
    }
}
