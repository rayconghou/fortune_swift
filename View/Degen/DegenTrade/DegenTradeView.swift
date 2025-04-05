//
//  DegenTradeView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI
import Combine

struct DegenTradeView: View {
    // Environment
    @Environment(\.colorScheme) var colorScheme
    
    // View model
    @StateObject private var viewModel = DegenTradeViewModel()
    
    // UI States
    @State private var selectedChain: Chain = .sol
    @State private var showBridgeModal = false
    @State private var searchText = ""
    @State private var isRefreshing = false
    
    // UI Colors
    var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(hex: "0A0E17")
    }
    
    var accentColor: Color {
        switch selectedChain {
        case .sol: return Color(hex: "14F195")
        case .eth: return Color(hex: "627EEA")
        case .base: return Color(hex: "0052FF")
        case .bsc: return Color(hex: "F3BA2F")
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Chain Selector
                chainSelectorView
                
                // Main Content
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.tokens.isEmpty {
                    emptyStateView
                } else {
                    tokenListView
                }
            }
            
            // Bridge Modal
            if showBridgeModal {
                bridgeModalView
            }
            
            // Floating action button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showBridgeModal = true
                    }) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .background(accentColor)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: accentColor.opacity(0.5), radius: 10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchTokens(for: selectedChain)
        }
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Degen Trader")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    isRefreshing = true
                    viewModel.fetchTokens(for: selectedChain)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isRefreshing = false
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                        .animation(isRefreshing ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                }
                
                Button(action: {
                    // Open settings
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                }
            }
            
            SearchBar(text: $searchText, placeholderText: "Search tokens...", backgroundColor: Color(hex: "171D2B"), textColor: .white, accentColor: accentColor)
                .onChange(of: searchText) { _ in
                    viewModel.filterTokens(searchText)
                }
        }
        .padding()
        .background(Color(hex: "0F131F"))
    }
    
    var chainSelectorView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Chain.allCases, id: \.self) { chain in
                    ChainButton(
                        chain: chain,
                        isSelected: selectedChain == chain,
                        accentColor: accentColor
                    )
                    .onTapGesture {
                        if selectedChain != chain {
                            selectedChain = chain
                            viewModel.fetchTokens(for: chain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(hex: "171D2B"))
    }
    
    var tokenListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredTokens) { token in
                    TokenCard(token: token, accentColor: accentColor)
                        .onTapGesture {
                            viewModel.selectedToken = token
                            // Handle token tap action - navigate to detail
                        }
                }
            }
            .padding()
        }
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: accentColor))
                .scaleEffect(1.5)
            Text("Loading tokens...")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 16)
            Spacer()
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No tokens found")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .padding(.top, 8)
            Text("Try a different search or chain")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
                .padding(.top, 4)
            Spacer()
        }
    }
    
    var bridgeModalView: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    showBridgeModal = false
                }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Bridge Assets")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showBridgeModal = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                // From chain selector
                BridgeChainSelector(
                    title: "From",
                    selectedChain: $viewModel.fromChain,
                    accentColor: accentColor
                )
                
                // Swap direction button
                Button(action: {
                    let temp = viewModel.fromChain
                    viewModel.fromChain = viewModel.toChain
                    viewModel.toChain = temp
                }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 16, weight: .bold))
                        .padding(10)
                        .background(Color(hex: "171D2B"))
                        .foregroundColor(accentColor)
                        .clipShape(Circle())
                }
                .padding(.vertical, 5)
                
                // To chain selector
                BridgeChainSelector(
                    title: "To",
                    selectedChain: $viewModel.toChain,
                    accentColor: accentColor
                )
                
                // Amount input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("0.0", text: $viewModel.bridgeAmount)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            // Set max amount
                            viewModel.setMaxBridgeAmount()
                        }) {
                            Text("MAX")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(accentColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(accentColor.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    .padding()
                    .background(Color(hex: "171D2B"))
                    .cornerRadius(12)
                }
                
                // Bridge quote
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Estimated gas:")
                        Spacer()
                        Text("~$\(viewModel.estimatedGas)")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    
                    HStack {
                        Text("You'll receive:")
                        Spacer()
                        Text("\(viewModel.estimatedReceiveAmount) \(viewModel.toChain.symbol)")
                            .fontWeight(.medium)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color(hex: "171D2B"))
                .cornerRadius(12)
                
                // Bridge button
                Button(action: {
                    viewModel.executeBridge()
                }) {
                    Text("Bridge Now")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [accentColor, accentColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: accentColor.opacity(0.3), radius: 10)
                }
                .disabled(!viewModel.canBridge)
                .opacity(viewModel.canBridge ? 1.0 : 0.6)
                
                // Li.Fi attribution
                Text("Powered by Li.Fi")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(24)
            .background(Color(hex: "0F131F"))
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.5), radius: 20)
            .padding(20)
        }
    }
}

// MARK: - Supporting Views

struct SearchBar: View {
    @Binding var text: String
    var placeholderText: String
    var backgroundColor: Color
    var textColor: Color
    var accentColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(textColor.opacity(0.5))
            
            TextField(placeholderText, text: $text)
                .foregroundColor(textColor)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(textColor.opacity(0.5))
                }
            }
        }
        .padding(10)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

struct ChainButton: View {
    var chain: Chain
    var isSelected: Bool
    var accentColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(chain.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(8)
                .background(
                    isSelected ?
                    accentColor.opacity(0.2) :
                    Color(hex: "232836")
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? accentColor : Color.clear,
                            lineWidth: 2
                        )
                )
            
            Text(chain.displayName)
                .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? accentColor : .gray)
        }
        .frame(width: 70)
    }
}

struct TokenCard: View {
    var token: Token
    var accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Token icon
            AsyncImage(url: URL(string: token.iconURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Circle()
                    .fill(Color(hex: "232836"))
                    .overlay(
                        Text(String(token.symbol.prefix(1)))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            // Token info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(token.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if token.isNew {
                        Text("NEW")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                }
                
                Text(token.name)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Token metrics
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(token.priceFormatted)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: token.priceChangePercentage >= 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 10))
                        .foregroundColor(token.priceChangePercentage >= 0 ? .green : .red)
                    
                    Text("\(abs(token.priceChangePercentage), specifier: "%.2f")%")
                        .font(.system(size: 12))
                        .foregroundColor(token.priceChangePercentage >= 0 ? .green : .red)
                }
            }
            
            // Action button
            Button(action: {
                // Action to trade token
            }) {
                Text("Trade")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(accentColor)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color(hex: "171D2B"))
        .cornerRadius(16)
    }
}

struct BridgeChainSelector: View {
    var title: String
    @Binding var selectedChain: Chain
    var accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            Menu {
                ForEach(Chain.allCases, id: \.self) { chain in
                    Button(action: {
                        selectedChain = chain
                    }) {
                        HStack {
                            Image(chain.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text(chain.displayName)
                            
                            Spacer()
                            
                            if selectedChain == chain {
                                Image(systemName: "checkmark")
                                    .foregroundColor(accentColor)
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(selectedChain.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(selectedChain.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(hex: "171D2B"))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Helper Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

struct DegenTradeView_Previews: PreviewProvider {
    static var previews: some View {
        DegenTradeView()
            .preferredColorScheme(.dark)
    }
}
