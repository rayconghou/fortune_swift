//
//  WalletSocialMediaTracker.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI

/// This view is what you use in your Degen tab item:
/// - If user hasn’t completed wallet setup: show PIN + FaceID flow
/// - If user already has a wallet: show the main wallet+sentiment
struct WalletSocialMediaTrackerView: View {
    @EnvironmentObject var viewModel: TradingWalletViewModel
    
    var body: some View {
        NavigationStack {
            if !viewModel.walletSetupComplete {
                // Show the onboarding flow
                onboardingFlow
            } else {
                // Show the main wallet+sentiment screen
                SideBySideView(viewModel: viewModel)
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


import SwiftUI

/// The master view that horizontally splits a "Wallet" section (left)
/// and a "Social Media Sentiment" section (right).
struct SideBySideView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @State private var selectedAsset: DegenAsset? = nil
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 16) {
                
                // Left side: Wallet
                LeftSideWalletView(viewModel: viewModel, selectedAsset: $selectedAsset)
                    .frame(width: geo.size.width * 0.5)
                    .background(Color(UIColor.systemBackground))
                
                // Right side: Social Media Sentiment
                RightSideSentimentView(viewModel: viewModel, selectedAsset: $selectedAsset)
                    .frame(width: geo.size.width * 0.5)
                    .background(Color(UIColor.systemBackground))
            }
        }
        .animation(.easeInOut, value: selectedAsset)
        .edgesIgnoringSafeArea(.bottom)
    }
}

/// A subview that displays the user's wallet, balance, and asset list.
struct LeftSideWalletView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Binding var selectedAsset: DegenAsset?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Wallet Balance")
                    .font(.headline)
                    .padding(.top, 8)
                
                Text("$\(String(format: "%.2f", viewModel.walletBalance))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
//                // List of assets
//                ForEach(viewModel.assets) { asset in
//                    AssetRow(
//                        asset: asset,
//                        isSelected: (asset == selectedAsset),
//                        onTap: {
//                            withAnimation {
//                                if selectedAsset == asset {
//                                    selectedAsset = nil
//                                } else {
//                                    selectedAsset = asset
//                                }
//                            }
//                        }
//                    )
//                }
            }
            .padding()
        }
    }
}

/// A subview that displays social media sentiment for either a selected asset
/// or all assets if none are selected.
struct RightSideSentimentView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Binding var selectedAsset: DegenAsset?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Social Media Sentiment")
                    .font(.headline)
                    .padding(.top, 8)
                
                HStack(spacing: 12) {
                    VStack {
                        Text("Market Bullish")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(viewModel.marketBullishPercentage)%")
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                    VStack {
                        Text("Market Bearish")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(viewModel.marketBearishPercentage)%")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                }
                
                if let chosenAsset = selectedAsset {
                    // Show sentiment for a single selected asset
                    SentimentView(asset: chosenAsset)
                        .padding(.horizontal, 8)
                } else {
                    // Show sentiment for all assets
                    ForEach(viewModel.assets) { asset in
                        SentimentView(asset: asset)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding()
        }
    }
}


struct SentimentBubble: View {
    var sentiment: Int
    
    var color: Color {
        if sentiment > 70 {
            return Color.green
        } else if sentiment > 50 {
            return Color.blue
        } else if sentiment > 30 {
            return Color.yellow
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

struct SentimentView: View {
    var asset: DegenAsset
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                    
                    Text(asset.symbol)
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(asset.name)
                        .fontWeight(.medium)
                    
                    HStack(spacing: 2) {
                        Text("$\(String(format: "%.2f", asset.price))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(asset.changeText)
                            .font(.caption)
                            .foregroundColor(asset.changeColor)
                    }
                }
                .padding(.leading, 8)
                
                Spacer()
                
                SentimentBubble(sentiment: asset.sentiment)
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Social Media Sentiment")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("LIVE")
                            .font(.system(size: 10))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                    }
                    
                    SentimentProgressBar(value: Double(asset.sentiment) / 100.0, color: asset.sentimentColor)
                        .frame(height: 8)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bullish")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 10))
                                .foregroundColor(.green)
                            Text("\(Int.random(in: 60...80))%")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bearish")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 10))
                                .foregroundColor(.red)
                            Text("\(Int.random(in: 20...40))%")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Neutral")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "minus")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            Text("\(Int.random(in: 5...15))%")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trend Analysis")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("24h Mentions")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("\(Int.random(in: 10...50))K")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Sentiment Shift")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(asset.trend == .up ? "+\(Int.random(in: 3...12))%" :
                                 (asset.trend == .down ? "-\(Int.random(in: 3...12))%" :
                                  "±\(Int.random(in: 1...3))%"))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(asset.trendColor)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Whale Activity")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text(Int.random(in: 0...1) == 0 ? "High" : "Moderate")
                                .font(.caption)
                                .fontWeight(.medium)
                                // Just color variety
                                .foregroundColor(Int.random(in: 0...1) == 0 ? .blue : .purple)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
