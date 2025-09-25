//
//  DexScreener.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation

/// Example structures if you plan to parse DexScreener token profiles or pairs
/// For brevity, keep only what's needed.

struct DexScreenerTokenProfile: Codable, Identifiable {
    let url: String
    let chainId: String
    let tokenAddress: String
    let icon: String?
    let header: String?
    let description: String?
    let links: [DexScreenerLink]?

    var id: String { "\(chainId)-\(tokenAddress)" }
}

struct DexScreenerLink: Codable {
    let type: String?
    let label: String?
    let url: String?
}

/// Another example for single pair responses
struct DexScreenerPairsResponse: Codable {
    let schemaVersion: String?
    let pairs: [DexPair]
}

struct DexPair: Codable, Identifiable {
    let chainId: String
    let pairAddress: String
    let baseToken: TokenInfo
    let quoteToken: TokenInfo
    let priceUsd: String?
    let marketCap: Double?
    let fdv: Double?
    let liquidity: Liquidity?
    let pairCreatedAt: Int?

    var id: String { "\(chainId)-\(pairAddress)" }
}

struct TokenInfo: Codable {
    let address: String
    let name: String
    let symbol: String
}

struct Liquidity: Codable {
    let usd: Double?
    let base: Double?
    let quote: Double?
}
