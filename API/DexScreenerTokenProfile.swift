//
//  DexScreenerTokenProfile.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation

/// A link structure within a token profile
// 1) New Codable for each link entry
struct DexScreenerLink: Codable {
    let label: String?
    let type: String?
    let url: String
}

// 2) Your existing token profile, updated
struct DexScreenerTokenProfile: Identifiable, Codable {
    // assume you already had these:
    let tokenAddress: String
    let chainId: String
    let description: String?
    let icon: String?

    // add:
    let links: [DexScreenerLink]?

    // for Identifiable conformance
    var id: String { tokenAddress }

    // 3) Computed properties to pull out just the URLs you care about
    var websiteURL: URL? {
        guard let link = links?.first(where: { $0.label?.lowercased() == "website" }),
              let url = URL(string: link.url) else { return nil }
        return url
    }
    var twitterURL: URL? {
        guard let link = links?.first(where: { $0.type?.lowercased() == "twitter" }),
              let url = URL(string: link.url) else { return nil }
        return url
    }
    var telegramURL: URL? {
        guard let link = links?.first(where: { $0.type?.lowercased() == "telegram" }),
              let url = URL(string: link.url) else { return nil }
        return url
    }
}


