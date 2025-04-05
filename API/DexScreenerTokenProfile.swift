//
//  DexScreenerTokenProfile.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation

/// Represents each "latest" token profile from DexScreener
struct DexScreenerTokenProfile: Codable, Identifiable {
    // If the API returns an array, each item presumably has these fields:
    let url: String
    let chainId: String
    let tokenAddress: String
    let icon: String?
    let header: String?
    let description: String?
    let links: [DexScreenerLink]?

    // Conform to Identifiable for SwiftUI ForEach
    var id: String { "\(chainId)-\(tokenAddress)" }
}

/// A link structure within a token profile
struct DexScreenerLink: Codable {
    let type: String?
    let label: String?
    let url: String?
}

