//
//  WalletSocialMediaTracker.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI

/// This view is what you use in your Degen tab item:
/// - If user hasn't completed wallet setup: show PIN + FaceID flow
/// - If user already has a wallet: show the main wallet+sentiment with toggle
struct WalletSocialMediaTrackerView: View {
    @EnvironmentObject var viewModel: TradingWalletViewModel
    
    var body: some View {
        NavigationStack {
            if !viewModel.walletSetupComplete {
                // Show the onboarding flow
                onboardingFlow
            } else {
                // Show the main wallet/sentiment screen with toggle
                ToggleableContentView(viewModel: viewModel)
                    .navigationBarTitle("SentimentTrader", displayMode: .inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var onboardingFlow: some View {
        switch viewModel.currentStep {
        case .createPin:
            CreatePINView(viewModel: viewModel)
        case .confirmPin:
            ConfirmPINView(viewModel: viewModel)
        case .biometricSetup:
            BiometricSetupView(viewModel: viewModel)
        case .setupComplete:
            SetupCompleteView(viewModel: viewModel)
        }
    }
}

/// New main view that toggles between "Wallet" and "Sentiment" using a slider
struct ToggleableContentView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @State private var selectedAsset: DegenAsset? = nil
    @State private var selectedMode: ContentMode = .wallet
    
    enum ContentMode: String, CaseIterable {
        case wallet = "Wallet"
        case sentiment = "Sentiment"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom toggle selector at the top
            ModeToggleSelector(selectedMode: $selectedMode)
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            // Dynamic content based on selection
            if selectedMode == .wallet {
                WalletView(viewModel: viewModel, selectedAsset: $selectedAsset)
            } else {
                SentimentAnalysisView(viewModel: viewModel, selectedAsset: $selectedAsset)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedMode)
        .background(Color(UIColor.systemBackground))
    }
}

/// Custom toggle slider between Wallet and Sentiment modes
struct ModeToggleSelector: View {
    @Binding var selectedMode: ToggleableContentView.ContentMode
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(ToggleableContentView.ContentMode.allCases, id: \.self) { mode in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMode = mode
                    }
                }) {
                    ZStack {
                        if selectedMode == mode {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .matchedGeometryEffect(id: "ToggleBackground", in: animation)
                                .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: mode == .wallet ? "creditcard.fill" : "bubble.left.and.bubble.right.fill")
                                .font(.subheadline)
                            
                            Text(mode.rawValue)
                                .fontWeight(.medium)
                                .font(.subheadline)
                        }
                        .foregroundColor(selectedMode == mode ? .white : .gray)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .frame(height: 44)
    }
}

/// The wallet view showing user's balance and assets
struct WalletView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Binding var selectedAsset: DegenAsset?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Card-like balance display
                BalanceCard(balance: viewModel.walletBalance)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Section header
                SectionHeader(title: "Your Assets", action: {})
                    .padding(.horizontal)
                
                // List of assets
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.assets) { asset in
                        AssetCardView(
                            asset: asset,
                            isSelected: (asset == selectedAsset),
                            onTap: {
                                withAnimation {
                                    if selectedAsset == asset {
                                        selectedAsset = nil
                                    } else {
                                        selectedAsset = asset
                                    }
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
            }
        }
    }
}

/// Card displaying wallet balance with visual flair
struct BalanceCard: View {
    var balance: Double
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Balance")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("$\(String(format: "%.2f", balance))")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "creditcard.fill")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            HStack {
                Label("Last updated 5m ago", systemImage: "clock.fill")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Button(action: {}) {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

/// Asset card with improved visual design
struct AssetCardView: View {
    var asset: DegenAsset
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Asset icon
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 48, height: 48)
                    
                    Text(asset.symbol)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .font(.subheadline)
                }
                
                // Asset info
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.name)
                        .font(.headline)
                        .foregroundColor(Color(UIColor.label))
                    
                    HStack(spacing: 8) {
                        Text("$\(String(format: "%.2f", asset.price))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(asset.changeText)
                            .font(.subheadline)
                            .foregroundColor(asset.changeColor)
                    }
                }
                
                Spacer()
                
                // Asset sentiment indicator
                SentimentBubble(sentiment: asset.sentiment)
                    .frame(width: 44, height: 44)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.black.opacity(0.05),
                            radius: isSelected ? 8 : 4,
                            x: 0,
                            y: isSelected ? 4 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Section header with title and optional action
struct SectionHeader: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Color(UIColor.label))
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
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

/// Filter chip component for sentiment categories
struct FilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : Color(UIColor.secondaryLabel))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .background(isSelected ?
                              AnyView(
                                  LinearGradient(
                                      gradient: Gradient(colors: [Color.blue, Color.purple]),
                                      startPoint: .leading,
                                      endPoint: .trailing
                                  )
                                  .clipShape(Capsule())
                              ) :
                              AnyView(
                                  Color(UIColor.tertiarySystemBackground)
                                      .clipShape(Capsule())
                              )
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 4, x: 0, y: 2)
        }
    }
}

/// Asset filter chip component
struct AssetFilterChip: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .blue : Color(UIColor.secondaryLabel))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue.opacity(0.1) : Color(UIColor.tertiarySystemBackground))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

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


