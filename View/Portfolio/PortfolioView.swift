//
//  PortfolioView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct PortfolioView: View {
    var hamburgerAction: () -> Void
    @State private var selectedTimeframe: Timeframe = .week
    @StateObject private var viewModel = PortfolioViewModel()
    @State private var showWalletSheet = false
    @State private var isDeposit = true
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 20) {
                    // Main balance card
                    VStack(spacing: 10) {
                        HStack {
                            Text("Total Balance")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            
                            Button(action: {
                                showWalletSheet = true
                                isDeposit = true
                            }) {
                                Label("Deposit", systemImage: "arrow.down.to.line")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(6)
                            
                            Button(action: {
                                showWalletSheet = true
                                isDeposit = false
                            }) {
                                Label("Withdraw", systemImage: "arrow.up.from.line")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(6)
                        }
                        
                        Text("$\(viewModel.totalBalance, specifier: "%.2f")")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            Image(systemName: viewModel.totalChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                .foregroundColor(viewModel.totalChange >= 0 ? .green : .red)
                            Text("\(viewModel.totalChange >= 0 ? "+" : "")\(viewModel.totalChangeValue, specifier: "$%.2f")")
                                .foregroundColor(viewModel.totalChange >= 0 ? .green : .red)
                            Text("(\(viewModel.totalChange, specifier: "%.2f")%)")
                                .foregroundColor(.gray)
                        }
                        .font(.subheadline)
                        
                        // P&L Timeframe Selector
                        HStack(spacing: 0) {
                            ForEach(Timeframe.allCases, id: \.self) { timeframe in
                                Button(action: {
                                    selectedTimeframe = timeframe
                                    viewModel.updatePnL(for: timeframe)
                                }) {
                                    Text(timeframe.rawValue)
                                        .font(.subheadline)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(selectedTimeframe == timeframe ? .white : .gray)
                                        .background(selectedTimeframe == timeframe ? Color(UIColor.systemGray5) : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        // P&L Metrics
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Unrealized P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.unrealizedPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.unrealizedPnL >= 0 ? .green : .red)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Realized P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.realizedPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.realizedPnL >= 0 ? .green : .red)
                                }
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Total P&L")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.totalPnL, specifier: "$%.2f")")
                                        .font(.headline)
                                        .foregroundColor(viewModel.totalPnL >= 0 ? .green : .white)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("% Change")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.totalPnLPercentage >= 0 ? "+" : "")\(viewModel.totalPnLPercentage, specifier: "%.2f")%")
                                        .font(.headline)
                                        .foregroundColor(viewModel.totalPnLPercentage >= 0 ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Wallet Selector
                    WalletSelectorView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Asset section header
                    HStack {
                        Text("Your Assets")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    if viewModel.portfolioAssets.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "briefcase")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                            Text("No Assets Yet")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Start your crypto journey by purchasing your first coin.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 40)
                            Button(action: {
                                // Navigate to buy screen if needed
                            }) {
                                Text("Buy Crypto")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.vertical, 50)
                    } else {
                        ForEach(viewModel.portfolioAssets) { asset in
                            AssetRow(asset: asset)
                                .padding(.horizontal)
                        }
                    }
                    
                    // News Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Latest News")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                viewModel.refreshNews()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if viewModel.isLoadingNews {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                Spacer()
                            }
                            .padding(.vertical, 20)
                        } else if viewModel.newsItems.isEmpty {
                            HStack {
                                Spacer()
                                Text("No news available")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.vertical, 20)
                        } else {
                            ForEach(viewModel.newsItems) { newsItem in
                                NewsItemView(newsItem: newsItem)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Blurred toolbar overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .ignoresSafeArea()
                .opacity(0.95)
        }
        .onAppear {
            viewModel.fetchData()
            viewModel.fetchNews()
        }
        .sheet(isPresented: $showWalletSheet) {
            WalletManagementView(isDeposit: isDeposit, viewModel: viewModel)
        }
    }
}
// MARK: - Models

enum Timeframe: String, CaseIterable {
    case day = "24h"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
}


// MARK: - Wallet Management Views

struct WalletSelectorView: View {
    @ObservedObject var viewModel = PortfolioViewModel()
    @State private var showWalletSheet = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Wallets")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    showWalletSheet = true
                }) {
                    Text("Manage")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.wallets) { wallet in
                        WalletCard(wallet: wallet, isSelected: wallet.id == viewModel.selectedWalletId)
                            .onTapGesture {
                                viewModel.selectedWalletId = wallet.id
                                viewModel.fetchData()
                            }
                    }
                    
                    Button(action: {
                        showWalletSheet = true
                    }) {
                        VStack(spacing: 10) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            
                            Text("Add Wallet")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .frame(width: 100, height: 80)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(16)
        .sheet(isPresented: $showWalletSheet) {
            WalletListView(viewModel: viewModel)
        }
    }
}

struct WalletCard: View {
    let wallet: PersonalWallet
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: wallet.iconName)
                    .foregroundColor(wallet.type.color)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Text(wallet.name)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.white)
            
            Text(wallet.balanceFormatted)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(10)
        .frame(width: 100, height: 80)
        .background(isSelected ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

struct WalletListView: View {
    @ObservedObject var viewModel = PortfolioViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showAddWalletSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.wallets) { wallet in
                    WalletListRow(wallet: wallet, isSelected: wallet.id == viewModel.selectedWalletId)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedWalletId = wallet.id
                            viewModel.fetchData()
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                .onDelete { indexSet in
                    viewModel.removeWallet(at: indexSet)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Your Wallets")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddWalletSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddWalletSheet) {
            AddWalletView(viewModel: viewModel)
        }
    }
}

struct WalletListRow: View {
    let wallet: PersonalWallet
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: wallet.iconName)
                .foregroundColor(wallet.type.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(wallet.name)
                    .font(.headline)
                
                Text(wallet.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(wallet.balanceFormatted)
                    .font(.headline)
                
                if isSelected {
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddWalletView: View {
    @ObservedObject var viewModel = PortfolioViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var walletType: PersonalWalletType = .bank
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Wallet Details")) {
                    TextField("Wallet Name", text: $name)
                    
                    Picker("Type", selection: $walletType) {
                        ForEach(PersonalWalletType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section {
                    Button("Add Wallet") {
                        viewModel.addWallet(name: name, type: walletType)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("Add New Wallet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct WalletManagementView: View {
    let isDeposit: Bool
    @ObservedObject var viewModel = PortfolioViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var amount = ""
    @State private var selectedPaymentMethod: PaymentMethod?
    @State private var showProcessingView = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Active wallet section
                if let wallet = viewModel.wallets.first(where: { $0.id == viewModel.selectedWalletId }) {
                    VStack(alignment: .center, spacing: 4) {
                        Text(isDeposit ? "Deposit to" : "Withdraw from")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: wallet.iconName)
                                .foregroundColor(wallet.type.color)
                            Text(wallet.name)
                                .font(.headline)
                        }
                        
                        Text(wallet.balanceFormatted)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                // Amount input
                VStack(alignment: .leading, spacing: 6) {
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("$")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        TextField("0.00", text: $amount)
                            .font(.system(size: 32, weight: .bold))
                            .keyboardType(.decimalPad)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
                
                // Payment method selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Payment Method")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(viewModel.paymentMethods) { method in
                                PaymentMethodRow(method: method, isSelected: selectedPaymentMethod?.id == method.id)
                                    .onTapGesture {
                                        selectedPaymentMethod = method
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Action button
                Button(action: {
                    showProcessingView = true
                    // Simulate processing delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if let amountValue = Double(amount), let wallet = viewModel.wallets.first(where: { $0.id == viewModel.selectedWalletId }) {
                            if isDeposit {
                                viewModel.depositToWallet(walletId: wallet.id, amount: amountValue)
                            } else {
                                viewModel.withdrawFromWallet(walletId: wallet.id, amount: amountValue)
                            }
                        }
                        showProcessingView = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text(isDeposit ? "Deposit Funds" : "Withdraw Funds")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(amount.isEmpty || selectedPaymentMethod == nil ? Color.gray : (isDeposit ? Color.green : Color.orange))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(amount.isEmpty || selectedPaymentMethod == nil)
            }
            .navigationTitle(isDeposit ? "Deposit" : "Withdraw")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .overlay(
                Group {
                    if showProcessingView {
                        ZStack {
                            Color.black.opacity(0.7)
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                                
                                Text(isDeposit ? "Processing Deposit..." : "Processing Withdrawal...")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding(30)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(15)
                        }
                    }
                }
            )
        }
    }
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: method.iconName)
                .font(.system(size: 24))
                .foregroundColor(method.type.color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(method.name)
                    .font(.headline)
                
                Text(method.detailsFormatted)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(isSelected ? Color(UIColor.systemGray5) : Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Models

class PortfolioViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var portfolioAssets: [PortfolioAsset] = []
    @Published var newsItems: [NewsItem] = []
    @Published var isLoadingNews = false
    @Published var wallets: [PersonalWallet] = []
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var selectedWalletId: String = ""
    
    @Published var totalBalance: Double = 0.0
    @Published var totalChange: Double = 0.0
    @Published var totalChangeValue: Double = 0.0
    @Published var unrealizedPnL: Double = 0.0
    @Published var realizedPnL: Double = 0.0
    @Published var totalPnL: Double = 0.0
    @Published var totalPnLPercentage: Double = 0.0
    
    // Sample portfolio holdings - in a real app, this would come from user data
    private let holdings = [
        AssetHolding(id: "bitcoin", amount: 0.5),
        AssetHolding(id: "ethereum", amount: 2.5),
        AssetHolding(id: "solana", amount: 25.0),
        AssetHolding(id: "cardano", amount: 1000.0)
    ]
    
    init() {
        setupWallets()
        setupPaymentMethods()
    }
    
    private func setupWallets() {
        wallets = [
            PersonalWallet(id: "wallet1", name: "Main Wallet", type: .personal, balance: 10543.27, iconName: "briefcase.fill"),
            PersonalWallet(id: "wallet2", name: "Savings", type: .savings, balance: 5321.89, iconName: "banknote"),
            PersonalWallet(id: "wallet3", name: "Chase Bank", type: .bank, balance: 2150.50, iconName: "building.columns.fill")
        ]
        
        // Set default selected wallet
        if let firstWallet = wallets.first {
            selectedWalletId = firstWallet.id
        }
    }
    
    private func setupPaymentMethods() {
        paymentMethods = [
            PaymentMethod(id: "bank1", name: "Chase Bank", type: .bank, details: "**** 4582", iconName: "building.columns.fill"),
            PaymentMethod(id: "card1", name: "Visa Debit", type: .card, details: "**** 7629", iconName: "creditcard.fill"),
            PaymentMethod(id: "card2", name: "Mastercard", type: .card, details: "**** 1284", iconName: "creditcard.fill"),
            PaymentMethod(id: "cash1", name: "Cash Deposit", type: .cash, details: "via ATM", iconName: "dollarsign.circle.fill")
        ]
    }
    
    func addWallet(name: String, type: PersonalWalletType) {
        let id = "wallet\(wallets.count + 1)"
        let iconName = type == .bank ? "building.columns.fill" : (type == .savings ? "banknote" : "briefcase.fill")
        let newWallet = PersonalWallet(id: id, name: name, type: type, balance: 0.0, iconName: iconName)
        wallets.append(newWallet)
    }
    
    func removeWallet(at indexSet: IndexSet) {
        wallets.remove(atOffsets: indexSet)
        
        // If selected wallet was removed, select the first wallet
        if !wallets.contains(where: { $0.id == selectedWalletId }) {
            selectedWalletId = wallets.first?.id ?? ""
        }
    }
    
    func depositToWallet(walletId: String, amount: Double) {
        if let index = wallets.firstIndex(where: { $0.id == walletId }) {
            wallets[index].balance += amount
        }
    }
    
    func withdrawFromWallet(walletId: String, amount: Double) {
        if let index = wallets.firstIndex(where: { $0.id == walletId }) {
            if wallets[index].balance >= amount {
                wallets[index].balance -= amount
            }
        }
    }
    
    func fetchData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching market data:", error)
                return
            }
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode([Coin].self, from: data)
                DispatchQueue.main.async {
                    self.coins = decoded
                    self.createPortfolioAssets()
                    self.calculateTotals()
                    self.updatePnL(for: .week)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
    
    func refreshData() {
        fetchData()
    }
    
    func fetchNews() {
        isLoadingNews = true
        
        // In a real app, this would fetch news for the assets in the portfolio
        // For now, we'll use mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.newsItems = self.getMockNewsItems()
            self.isLoadingNews = false
        }
    }
    
    func refreshNews() {
        fetchNews()
    }
    
    private func getMockNewsItems() -> [NewsItem] {
        // Generate news based on the assets in portfolio
        var news: [NewsItem] = []
        
        // Bitcoin news
        if holdings.contains(where: { $0.id == "bitcoin" }) {
            news.append(
                NewsItem(
                    id: "btc1",
                    title: "Bitcoin Hits New Monthly High as Institutional Adoption Grows",
                    description: "Large financial institutions continue to increase their Bitcoin holdings as the asset shows strong resilience in the market.",
                    source: "Crypto Daily",
                    url: "https://cryptodaily.com/bitcoin-institutional-adoption",
                    publishedAt: "2025-04-08T14:30:00Z",
                    imageUrl: "https://example.com/bitcoin-news.jpg",
                    relatedAssetId: "bitcoin"
                )
            )
            
            news.append(
                NewsItem(
                    id: "btc2",
                    title: "Bitcoin Mining Difficulty Reaches All-Time High",
                    description: "Bitcoin's network difficulty adjustment has hit a new record, reflecting growing computing power dedicated to securing the network.",
                    source: "Block Insight",
                    url: "https://blockinsight.com/bitcoin-mining-difficulty",
                    publishedAt: "2025-04-07T16:45:00Z",
                    imageUrl: "https://example.com/bitcoin-mining.jpg",
                    relatedAssetId: "bitcoin"
                )
            )
        }
        
        // Ethereum news
        if holdings.contains(where: { $0.id == "ethereum" }) {
            news.append(
                NewsItem(
                    id: "eth1",
                    title: "Ethereum Layer 2 Solutions See Surge in User Activity",
                    description: "Rollup technologies on Ethereum continue to gain traction as users seek lower fees and faster transactions.",
                    source: "ETH World",
                    url: "https://ethworld.com/layer2-activity",
                    publishedAt: "2025-04-09T09:15:00Z",
                    imageUrl: "https://example.com/ethereum-l2.jpg",
                    relatedAssetId: "ethereum"
                )
            )
            
            news.append(
                NewsItem(
                    id: "eth2",
                    title: "Ethereum Developer Conference Announces New Protocol Upgrades",
                    description: "The latest Ethereum developer summit revealed plans for upcoming improvements to the network's scalability and security.",
                    source: "DeFi Pulse",
                    url: "https://defipulse.com/eth-developer-conf",
                    publishedAt: "2025-04-06T11:20:00Z",
                    imageUrl: "https://example.com/ethereum-dev.jpg",
                    relatedAssetId: "ethereum"
                )
            )
        }
        
        // Solana news
        if holdings.contains(where: { $0.id == "solana" }) {
            news.append(
                NewsItem(
                    id: "sol1",
                    title: "Solana NFT Market Continues to Set New Records",
                    description: "The Solana NFT ecosystem has seen unprecedented growth in trading volume and new project launches.",
                    source: "SOL News",
                    url: "https://solnews.com/nft-market-growth",
                    publishedAt: "2025-04-08T12:10:00Z",
                    imageUrl: "https://example.com/solana-nft.jpg",
                    relatedAssetId: "solana"
                )
            )
        }
        
        // Cardano news
        if holdings.contains(where: { $0.id == "cardano" }) {
            news.append(
                NewsItem(
                    id: "ada1",
                    title: "Cardano Foundation Launches Developer Grant Program",
                    description: "A new initiative aims to accelerate the development of DApps and infrastructure on the Cardano blockchain.",
                    source: "Cardano Insider",
                    url: "https://cardanoinsider.com/grant-program",
                    publishedAt: "2025-04-07T10:45:00Z",
                    imageUrl: "https://example.com/cardano-dev.jpg",
                    relatedAssetId: "cardano"
                )
            )
        }
        
        // General crypto news
        news.append(
            NewsItem(
                id: "gen1",
                title: "New Crypto Regulations Set to Impact Global Markets",
                description: "Lawmakers in major economies have announced coordinated regulatory frameworks for cryptocurrency assets.",
                source: "Crypto Reports",
                url: "https://cryptoreports.com/global-regulations",
                publishedAt: "2025-04-09T08:30:00Z",
                imageUrl: "https://example.com/crypto-regulations.jpg",
                relatedAssetId: nil
            )
        )
        
        return news.shuffled() // Randomize order for variety
    }

    private func createPortfolioAssets() {
        portfolioAssets = []
        
        for holding in holdings {
            if let coin = coins.first(where: { $0.id == holding.id }) {
                let totalValue = coin.current_price * holding.amount
                let asset = PortfolioAsset(
                    id: coin.id,
                    name: coin.name,
                    symbol: coin.symbol,
                    amount: holding.amount,
                    currentPrice: coin.current_price,
                    totalValue: totalValue,
                    priceChangePercentage: coin.price_change_percentage_24h ?? 0,
                    imageUrl: coin.image
                )
                portfolioAssets.append(asset)
            }
        }
    }

    private func calculateTotals() {
        totalBalance = portfolioAssets.reduce(0) { $0 + $1.totalValue }
        
        // Calculate overall change based on 24h percentage
        let weightedChange = portfolioAssets.reduce(0.0) {
            $0 + ($1.priceChangePercentage * ($1.totalValue / max(1, totalBalance)))
        }
        totalChange = weightedChange
        totalChangeValue = totalBalance * (totalChange / 100)
    }

    func updatePnL(for timeframe: Timeframe) {
        // In a real app, this would use historical data for the selected timeframe
        // For this demo, we'll use simulated values based on the timeframe
        switch timeframe {
        case .day:
            unrealizedPnL = totalBalance * 0.02
            realizedPnL = totalBalance * -0.005
        case .week:
            unrealizedPnL = totalBalance * 0.045
            realizedPnL = totalBalance * -0.003
        case .month:
            unrealizedPnL = totalBalance * 0.12
            realizedPnL = totalBalance * 0.01
        case .year:
            unrealizedPnL = totalBalance * 0.35
            realizedPnL = totalBalance * 0.05
        case .all:
            unrealizedPnL = totalBalance * 0.65
            realizedPnL = totalBalance * 0.15
        }
        
        totalPnL = unrealizedPnL + realizedPnL
        totalPnLPercentage = (totalPnL / totalBalance) * 100
    }
}

// MARK: - Asset Models



// MARK: - Wallet Models

enum PersonalWalletType: String, CaseIterable {
    case personal = "Personal"
    case savings = "Savings"
    case bank = "Bank Account"
    
    var color: Color {
        switch self {
        case .personal:
            return .blue
        case .savings:
            return .green
        case .bank:
            return .purple
        }
    }
}

struct PersonalWallet: Identifiable {
    let id: String
    let name: String
    let type: PersonalWalletType
    var balance: Double
    let iconName: String
    
    var balanceFormatted: String {
        String(format: "$%.2f", balance)
    }
}

// MARK: - Payment Method Models

enum PaymentMethodType: String, CaseIterable {
    case bank = "Bank Account"
    case card = "Card"
    case cash = "Cash"
    
    var color: Color {
        switch self {
        case .bank:
            return .purple
        case .card:
            return .blue
        case .cash:
            return .green
        }
    }
}

struct PaymentMethod: Identifiable {
    let id: String
    let name: String
    let type: PaymentMethodType
    let details: String
    let iconName: String
    
    var detailsFormatted: String {
        switch type {
        case .bank:
            return "Account \(details)"
        case .card:
            return "Card \(details)"
        case .cash:
            return details
        }
    }
}

// MARK: - Data Models

struct PortfolioCoin: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double?
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(hamburgerAction: {})
            .preferredColorScheme(.dark)
    }
}

