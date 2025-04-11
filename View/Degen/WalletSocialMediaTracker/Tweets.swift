//
//  Tweets.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 4/9/25.
//

import Foundation
import SwiftUI

/// Twitter-like card for sentiment analysis
struct TweetCard: View {
    var asset: DegenAsset
    var influencerType: SentimentAnalysisView.SentimentFilter
    
    // Sample data
    private var influencerName: String {
        switch influencerType {
        case .celebrities:
            return ["Elon Musk", "Mark Cuban", "Cathie Wood", "Chamath Palihapitiya", "Tim Draper"].randomElement()!
        case .whales:
            return ["Whale_Trader", "DefiGiant", "CryptoWhale", "TokenMaster", "BlockchainMonster"].randomElement()!
        case .trending:
            return ["@\(asset.symbol)Fan", "CryptoInsider", "MarketWatcher", "TradingPro", "FinanceGuru"].randomElement()!
        }
    }
    
    private var username: String {
        "@\(influencerName.replacingOccurrences(of: " ", with: ""))"
    }
    
    private var tweetTime: String {
        let times = ["2m", "15m", "32m", "1h", "3h", "5h"]
        return times.randomElement()!
    }
    
    private var tweetContent: String {
        let bullishTweets = [
            "$\(asset.symbol) looking really strong today. Technical indicators suggest possible breakout soon. #bullish",
            "Just increased my position in $\(asset.symbol). The fundamentals are better than ever. Long term hold.",
            "The team behind $\(asset.symbol) just announced a major partnership. This is huge news! 🚀",
            "$\(asset.symbol) chart forming a classic cup and handle. Expecting major movement in the next few days.",
            "Been following $\(asset.symbol) for months. This is the accumulation phase before the next leg up."
        ]
        
        let bearishTweets = [
            "Not liking what I'm seeing with $\(asset.symbol). Volume dropping off, might be time to take profits.",
            "$\(asset.symbol) showing weakness at key resistance levels. Proceed with caution.",
            "Just reduced my exposure to $\(asset.symbol). Risk/reward ratio isn't favorable right now.",
            "The latest news about $\(asset.symbol) is concerning. Might test support levels soon.",
            "$\(asset.symbol) technicals looking bearish on the 4h chart. Watch closely."
        ]
        
        return asset.sentiment > 50 ? bullishTweets.randomElement()! : bearishTweets.randomElement()!
    }
    
    private var engagementNumbers: (likes: Int, retweets: Int) {
        let magnitude = influencerType == .celebrities ? 1000 : 100
        return (
            likes: Int.random(in: 1...40) * magnitude,
            retweets: Int.random(in: 1...15) * magnitude
        )
    }
    
    private var sentimentIcon: String {
        asset.sentiment > 65 ? "arrow.up.circle.fill" :
            (asset.sentiment < 35 ? "arrow.down.circle.fill" : "minus.circle.fill")
    }
    
    private var sentimentColor: Color {
        asset.sentiment > 65 ? .green :
            (asset.sentiment < 35 ? .red : .orange)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with influencer info
            HStack(spacing: 12) {
                // Profile pic placeholder
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 44, height: 44)
                    
                    Text(String(influencerName.prefix(1)))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(influencerName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if influencerType == .celebrities || influencerType == .whales {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text(username)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(tweetTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Sentiment indicator
                Image(systemName: sentimentIcon)
                    .foregroundColor(sentimentColor)
                    .font(.headline)
            }
            
            // Tweet content
            Text(tweetContent)
                .font(.subheadline)
                .lineSpacing(4)
            
            // Asset tag
            HStack {
                Text("$\(asset.symbol)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Spacer()
            }
            
            // Tweet engagement stats
            HStack(spacing: 16) {
                Label("\(engagementNumbers.likes)", systemImage: "heart")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Label("\(engagementNumbers.retweets)", systemImage: "arrow.2.squarepath")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

/// Sentiment bubble component (keep the existing one with slight updates)
struct SentimentBubble: View {
    var sentiment: Int
    
    var color: Color {
        if sentiment > 70 {
            return Color.green
        } else if sentiment > 50 {
            return Color.blue
        } else if sentiment > 30 {
            return Color.orange
        } else {
            return Color.red
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
            
            Circle()
                .stroke(color, lineWidth: 2)
            
            Text("\(sentiment)%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

/// The sentiment analysis view showing Twitter trends
struct SentimentAnalysisView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Binding var selectedAsset: DegenAsset?
    @State private var selectedFilter: SentimentFilter = .trending
    
    enum SentimentFilter: String, CaseIterable {
        case trending = "Trending"
        case celebrities = "Celebrities"
        case whales = "Whales"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(SentimentFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter,
                            action: {
                                withAnimation {
                                    selectedFilter = filter
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            
            // Asset filter chip row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    AssetFilterChip(
                        title: "All Assets",
                        isSelected: selectedAsset == nil,
                        action: {
                            withAnimation {
                                selectedAsset = nil
                            }
                        }
                    )
                    
                    ForEach(viewModel.assets) { asset in
                        AssetFilterChip(
                            title: asset.symbol,
                            isSelected: selectedAsset == asset,
                            action: {
                                withAnimation {
                                    if selectedAsset == asset {
                                        selectedAsset = nil
                                    } else {
                                        selectedAsset = asset
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
            
            // Sentiment tweets
            ScrollView {
                LazyVStack(spacing: 16) {
                    if let asset = selectedAsset {
                        // Show tweets for selected asset
                        ForEach(0..<5) { _ in
                            TweetCard(
                                asset: asset,
                                influencerType: selectedFilter
                            )
                        }
                    } else {
                        // Show tweets for all assets
                        ForEach(viewModel.assets) { asset in
                            TweetCard(
                                asset: asset,
                                influencerType: selectedFilter
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
}
