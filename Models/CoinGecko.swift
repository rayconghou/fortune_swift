//
//  CoinGecko.swift
//  Dojo
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation

// Matches the structure of the JSON from CoinGecko's /simple/price (with 24h change)
struct CoingeckoSimplePrice: Decodable {
    let bitcoin:  PriceInfo?
    let ethereum: PriceInfo?
    let solana:   PriceInfo?
    
    struct PriceInfo: Decodable {
        let usd: Double
        let usd_24h_change: Double
    }
}
