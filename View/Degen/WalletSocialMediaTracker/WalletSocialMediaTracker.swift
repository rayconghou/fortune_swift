//
//  WalletSocialMediaTracker.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI

/// This view is what you use in your Degen tab item:
/// - If user hasn't completed wallet setup: show PIN + FaceID flow
/// - If user already has a wallet: show the main wallet+sentiment with toggle
struct WalletSocialMediaTrackerView: View {
    @EnvironmentObject var viewModel: TradingWalletViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ToggleableContentView(viewModel: viewModel)
                .navigationTitle("Tracker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: {
                                // Trigger notifications
                            }) {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                            }
                            Button(action: {
                                // Show info sheet or view
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                            }
                        }                        }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
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
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            // Dynamic content based on selection
            if selectedMode == .wallet {
                WalletView(viewModel: viewModel, selectedAsset: $selectedAsset)
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
            } else {
                SentimentAnalysisView(viewModel: viewModel, selectedAsset: $selectedAsset)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedMode)
        .background(Color("BackgroundDark", bundle: .main) ?? Color(UIColor.systemBackground))
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
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .matchedGeometryEffect(id: "ToggleBackground", in: animation)
                                .shadow(color: Color.blue.opacity(0.4), radius: 6, x: 0, y: 3)
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: mode == .wallet ? "creditcard.fill" : "bubble.left.and.bubble.right.fill")
                                .font(.callout)
                                .foregroundStyle(
                                    selectedMode == mode ?
                                    LinearGradient(colors: [.white, .white.opacity(0.8)], startPoint: .top, endPoint: .bottom) :
                                    LinearGradient(colors: [.gray.opacity(0.8), .gray.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                                )
                            
                            Text(mode.rawValue)
                                .fontWeight(.medium)
                                .font(.callout)
                        }
                        .foregroundColor(selectedMode == mode ? .white : .gray)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(
                            colors: [.white.opacity(0.1), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 0.5)
                )
        )
        .frame(height: 48)
    }
}

/// The wallet view showing user's balance and assets
struct WalletView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Binding var selectedAsset: DegenAsset?
    @State private var selectedWallet: TrackedWallet?
    @State private var showingAddWalletSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Tracked Wallets")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    showingAddWalletSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.footnote)
                        
                        Text("Add")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .foregroundColor(.white)
                }
                .padding(.trailing)
            }
            .padding(.top, 8)

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.trackedWallets) { wallet in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedWallet == wallet {
                                    selectedWallet = nil
                                } else {
                                    selectedWallet = wallet
                                }
                            }
                        }) {
                            TrackedWalletCard(wallet: wallet, isSelected: wallet == selectedWallet)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 24)
            }
            
            if let wallet = selectedWallet {
                HStack {
                    Text("Wallet Analytics")
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            selectedWallet = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                .padding(.horizontal)
                
                WalletDetailView(wallet: wallet)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingAddWalletSheet) {
            AddPublicWalletView(viewModel: viewModel)
        }
    }
}

struct TrackedWalletCard: View {
    let wallet: TrackedWallet
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: "wallet.pass.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.trailing, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(wallet.label)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(wallet.shortAddress)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(wallet.formattedBalance)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(wallet.pnlText)
                    .font(.caption)
                    .foregroundColor(wallet.pnlColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(wallet.pnlColor.opacity(0.15))
                    .cornerRadius(4)
            }

            Image(systemName: isSelected ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                .foregroundColor(isSelected ? .blue : .gray.opacity(0.7))
                .font(.footnote)
                .padding(.leading, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(isSelected ? 0.2 : 0.05),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct WalletDetailView: View {
    let wallet: TrackedWallet
    @State private var selectedTimeframe: TimeFrame = .week
    
    enum TimeFrame: String, CaseIterable {
        case day = "24H"
        case week = "7D"
        case month = "30D"
        case year = "1Y"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Performance chart mock
            HStack {
                ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                    Button(action: {
                        withAnimation {
                            selectedTimeframe = timeframe
                        }
                    }) {
                        Text(timeframe.rawValue)
                            .font(.caption)
                            .fontWeight(selectedTimeframe == timeframe ? .bold : .medium)
                            .foregroundColor(selectedTimeframe == timeframe ? .white : .gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                selectedTimeframe == timeframe ?
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    ) : nil
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Mock chart
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackgroundDark", bundle: .main) ?? Color.black.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    ZStack {
                        // This is a placeholder for where you'd put actual chart data
                        Path { path in
                            let width: CGFloat = UIScreen.main.bounds.width - 80
                            let height: CGFloat = 80
                            
                            // Mock data points
                            let points = [
                                CGPoint(x: 0, y: height * 0.5),
                                CGPoint(x: width * 0.2, y: height * 0.4),
                                CGPoint(x: width * 0.4, y: height * 0.7),
                                CGPoint(x: width * 0.6, y: height * 0.3),
                                CGPoint(x: width * 0.8, y: height * 0.5),
                                CGPoint(x: width, y: height * 0.2)
                            ]
                            
                            path.move(to: points[0])
                            for point in points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                        
                        // Gradient fill below the line
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.1), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Path { path in
                                let width: CGFloat = UIScreen.main.bounds.width - 80
                                let height: CGFloat = 80
                                
                                // Mock data points
                                let points = [
                                    CGPoint(x: 0, y: height * 0.5),
                                    CGPoint(x: width * 0.2, y: height * 0.4),
                                    CGPoint(x: width * 0.4, y: height * 0.7),
                                    CGPoint(x: width * 0.6, y: height * 0.3),
                                    CGPoint(x: width * 0.8, y: height * 0.5),
                                    CGPoint(x: width, y: height * 0.2)
                                ]
                                
                                path.move(to: CGPoint(x: 0, y: height))
                                path.addLine(to: points[0])
                                for point in points.dropFirst() {
                                    path.addLine(to: point)
                                }
                                path.addLine(to: CGPoint(x: width, y: height))
                                path.closeSubpath()
                            }
                        )
                    }
                    .padding()
                )
            
            // Wallet stats
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Balance")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(wallet.formattedBalance)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Performance")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(wallet.pnlText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(wallet.pnlColor)
                    }
                }
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Transactions")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(wallet.transactions.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Activity")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(wallet.transactionFrequency)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {
                    // Action to view full details
                }) {
                    Text("View Transactions")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.tertiarySystemBackground))
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.1), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .padding(.bottom, 24)
    }
}

struct AddPublicWalletView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isAddressFieldFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.black, Color(hex: "101318")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 40)
                    
                    Text("Add New Wallet")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Wallet Address")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                            
                            TextField("", text: $viewModel.newWalletAddress)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.secondarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.1), Color.clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 1
                                        )
                                )
                                .focused($isAddressFieldFocused)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isAddressFieldFocused = true
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Wallet Label (Optional)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                            
                            TextField("", text: $viewModel.newWalletLabel)
                                .placeholder(when: viewModel.newWalletLabel.isEmpty) {
                                    Text("My Trading Wallet")
                                        .foregroundColor(.gray.opacity(0.5))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.secondarySystemBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.1), Color.clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Support for QR code scanning
                    Button(action: {
                        // QR code scanning action would go here
                    }) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                            Text("Scan QR Code")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.secondarySystemBackground))
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.addCustomWallet()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Import Wallet")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: viewModel.newWalletAddress.isEmpty ?
                                                    [.gray.opacity(0.3), .gray.opacity(0.2)] :
                                                    [.blue, .purple.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: viewModel.newWalletAddress.isEmpty ?
                                            Color.clear :
                                            Color.blue.opacity(0.3),
                                            radius: 8, x: 0, y: 4)
                            )
                    }
                    .disabled(viewModel.newWalletAddress.isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.tertiarySystemBackground))
                        )
                }
            )
        }
        .preferredColorScheme(.dark)
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
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .foregroundColor(.clear) // Needed to keep shape layout
                        .background(
                            isSelected
                            ? AnyView(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            : AnyView(
                                Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.tertiarySystemBackground)
                            )
                        )
                        .shadow(color: isSelected ? Color.blue.opacity(0.4) : Color.clear, radius: 6, x: 0, y: 3)
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
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
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue.opacity(0.15) : Color("CardBackgroundDark", bundle: .main) ?? Color(UIColor.tertiarySystemBackground))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// Helper extensions
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
