//
//  ContentView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 2/28/25.
//

import SwiftUI
import Combine

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}

// MARK: - Main ContentView with Splash Screen

struct ContentView: View {
    @State private var hideSplash = false
    @State private var showFortune = false
    @State private var showCollective = false
    @State private var showBottomElements = false
    
    var body: some View {
        ZStack {
            HomePageView()
            
            splashScreen
                .offset(y: hideSplash ? -UIScreen.main.bounds.height : 0)
                .animation(.easeInOut(duration: 1.5).delay(0.75), value: hideSplash)
        }
        .ignoresSafeArea()
        .onAppear {
            showFortune = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCollective = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showBottomElements = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { hideSplash = true }
            }
        }
    }
    
    var splashScreen: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("FORTUNE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 48))
                    .opacity(showFortune ? 1 : 0)
                    .animation(.easeIn(duration: 0.1).delay(0.3), value: showFortune)
                Text("COLLECTIVE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 24))
                    .opacity(showFortune ? 1 : 0)
                    .animation(.easeIn(duration: 0.1).delay(1.0), value: showFortune)
                    .padding(.bottom, 20)
                VStack {
                    Divider()
                        .background(Color.white)
                        .frame(width: 200, height: 5)
                    Image("SplashScreenBranding")
                        .resizable()
                        .frame(width: 200, height: 210)
                }
                .opacity(showBottomElements ? 1 : 0)
                .offset(y: showBottomElements ? 0 : 50)
                .animation(.easeOut(duration: 0.5).delay(0.5), value: showBottomElements)
            }
        }
    }
}

// MARK: - HomePageView with TabView and Sidebar

struct HomePageView: View {
    @State private var showSidebar = false
    @State private var hideHamburger = false
    @State private var showDegenMode = false
    
    var body: some View {
        ZStack {
            TabView {
                // Left-most tab: Spotting
                SpottingView(hideHamburger: $hideHamburger)
                    .tabItem {
                        Image(systemName: "binoculars.fill")
                        Text("Spotting")
                    }
                // Second tab: Indexes
                IndexesView()
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Indexes")
                    }
                // Middle (largest) tab: Maneki
                ManekiView()
                    .tabItem {
                        Image(systemName: "cat.fill")
                            .font(.system(size: 28))
                        Text("Maneki")
                    }
                // Fourth tab: Portfolio
                PortfolioView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Portfolio")
                    }
                // Right-most tab: Degen Mode
                DegenView(isEnabled: $showDegenMode)
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Degen")
                    }
            }
            .offset(x: showSidebar ? UIScreen.main.bounds.width * 0.75 : 0)
            .animation(.easeInOut(duration: 0.3), value: showSidebar)
            
            if showSidebar {
                SidebarView(showSidebar: $showSidebar, showDegenMode: $showDegenMode)
                    .transition(.move(edge: .leading))
            }
            
            // Hamburger button shows only when sidebar is closed
            VStack {
                HStack {
                    if !showSidebar && !hideHamburger {
                        Button(action: {
                            withAnimation { showSidebar.toggle() }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding(.top, 60)
                                .padding(.leading, 25)
                                .padding(.bottom, 10)
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Sidebar with Extra Options

struct SidebarView: View {
    @Binding var showSidebar: Bool
    @Binding var showDegenMode: Bool
    @State private var showManekiIntro = false
    @State private var showChatroom = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Close Button
                HStack {
                    Button(action: { withAnimation { showSidebar.toggle() } }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading, 25)
                            .padding(.bottom, 20)
                    }
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 20) {
                    // Profile
                    Button(action: { print("Profile button pressed") }) {
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("James Wang")
                                    .font(.custom("Inter", size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Manage Profile")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing, 30)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                    }
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                    
                    // Degen Mode Toggle
                    HStack {
                        Image(systemName: "flame.fill")
                        Text("Degen Mode")
                            .font(.custom("Inter", size: 18))
                        Spacer()
                        Toggle("", isOn: $showDegenMode)
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            .padding(.trailing, 30)
                    }
                    .padding(.leading, 30)
                    .foregroundColor(.white)
                    
                    // Maneki Guide
                    Button(action: { showManekiIntro = true }) {
                        HStack {
                            Image(systemName: "cat.fill")
                            Text("Maneki Guide")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showManekiIntro) {
                        ManekiIntroView()
                    }
                    
                    // Chatroom
                    Button(action: { showChatroom = true }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Chatroom")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    .sheet(isPresented: $showChatroom) {
                        ChatroomView()
                    }
                    
                    // Community Hub
                    NavigationLink(destination: CommunityHubView()) {
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("Community Hub")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    // Newsletter
                    NavigationLink(destination: NewsletterView()) {
                        HStack {
                            Image(systemName: "newspaper.fill")
                            Text("Newsletter")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    Divider()
                        .frame(width: 20, height: 1)
                        .background(Color.white)
                        .padding(.leading, 30)
                    
                    // Reserve / Apply
                    NavigationLink(destination: ReserveView()) {
                        HStack {
                            Image(systemName: "key")
                            Text("Reserve")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    
                    // Settings & Notifications
                    Button(action: { print("Settings button pressed") }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }
                    Button(action: { print("Notifications button pressed") }) {
                        HStack {
                            Image(systemName: "bell")
                            Text("Notifications")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                    }

                    // Logout
                    Button(action: { print("Logout button pressed") }) {
                        HStack {
                            Image(systemName: "power")
                            Text("Logout")
                                .font(.custom("Inter", size: 18))
                        }
                        .padding(.leading, 30)
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

// MARK: - Real-Time Crypto Updates with CoinGecko API

class CryptoPriceViewModel: ObservableObject {
    @Published var btcPrice: Double = 0.0
    @Published var btc24hChange: Double = 0.0
    
    @Published var ethPrice: Double = 0.0
    @Published var eth24hChange: Double = 0.0
    
    @Published var solPrice: Double = 0.0
    @Published var sol24hChange: Double = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    
    // Timer that automatically fires every 5 seconds (you can set to 10, etc):
    private var fetchTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init() {
        // Immediately fetch on init:
        fetchData()
        
        // Re-fetch whenever the timer fires:
        fetchTimer
            .sink { [weak self] _ in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    /// Fetches BTC, ETH, and SOL in USD (and their 24h changes)
    func fetchData() {
        guard let url = URL(string:
          "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd&include_24hr_change=true"
        ) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data:", error)
                return
            }
            guard let data = data else { return }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(dataString)")
            }
            
            do {
                // JSON shape with &include_24hr_change=true looks like:
                // {
                //   "bitcoin":  { "usd": 22884.2, "usd_24h_change": -2.79133 ... },
                //   "ethereum": { "usd": 1550.50, "usd_24h_change": 4.1234 ... },
                //   "solana":   { "usd": 25.12,   "usd_24h_change": 0.5432 ... }
                // }
                let decoded = try JSONDecoder().decode(CoingeckoSimplePrice.self, from: data)
                DispatchQueue.main.async {
                    // Check that each coin is present; if not, log an error and avoid updating the UI.
                    guard let bitcoin = decoded.bitcoin else {
                        print("Error: 'bitcoin' field is missing in the JSON response.")
                        return
                    }
                    guard let ethereum = decoded.ethereum else {
                        print("Error: 'ethereum' field is missing in the JSON response.")
                        return
                    }
                    guard let solana = decoded.solana else {
                        print("Error: 'solana' field is missing in the JSON response.")
                        return
                    }
                    
                    self.btcPrice       = bitcoin.usd
                    self.btc24hChange   = bitcoin.usd_24h_change
                    self.ethPrice       = ethereum.usd
                    self.eth24hChange   = ethereum.usd_24h_change
                    self.solPrice       = solana.usd
                    self.sol24hChange   = solana.usd_24h_change
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

/// Matches the structure of the JSON from CoinGecko's /simple/price (with 24h change)
struct CoingeckoSimplePrice: Decodable {
    let bitcoin:  PriceInfo?
    let ethereum: PriceInfo?
    let solana:   PriceInfo?
    
    struct PriceInfo: Decodable {
        let usd: Double
        let usd_24h_change: Double
    }
}

// MARK: - SpottingView

struct SpottingView: View {
    // If you need the hamburger logic from your code:
    @Binding var hideHamburger: Bool
    
    // 1) Create a single ViewModel instance for prices
    @StateObject var priceVM = CryptoPriceViewModel()
    
    @State private var scrollOffset: CGFloat = 0
    @State private var showBuyModal = false
    @State private var showSellModal = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: OffsetPreferenceKey.self,
                                    value: geo.frame(in: .global).minY)
                }
                .frame(height: 1)
                
                VStack(spacing: 16) {
                    Text("Market Trends")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    // 2) Replace static prices with live data from the ViewModel:
                    CryptoTrendCard(
                        name: "Bitcoin",
                        symbol: "BTC",
                        price: priceVM.btcPrice,
                        change: priceVM.btc24hChange
                    )
                    
                    CryptoTrendCard(
                        name: "Ethereum",
                        symbol: "ETH",
                        price: priceVM.ethPrice,
                        change: priceVM.eth24hChange
                    )
                    
                    CryptoTrendCard(
                        name: "Solana",
                        symbol: "SOL",
                        price: priceVM.solPrice,
                        change: priceVM.sol24hChange
                    )
                    
                    // Market News, etc...
                    Text("Market News")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    NewsCard(title: "Bitcoin Reaches New All-Time High", time: "2 hours ago")
                    NewsCard(title: "SEC Approves New Crypto ETF", time: "5 hours ago")
                    NewsCard(title: "Major Bank Adopts Blockchain Technology", time: "1 day ago")
                    
                    // Extra bottom padding for floating buttons
                    Spacer().frame(height: 75)
                }
                .padding(.horizontal)
            }
            .background(Color.black)
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                scrollOffset = value
            }
            
            // Floating BUY & SELL buttons
            HStack(spacing: 20) {
                Button(action: { showBuyModal = true }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("BUY")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                
                Button(action: { showSellModal = true }) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("SELL")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .sheet(isPresented: $showBuyModal) {
            BuyCryptoView()
        }
        .sheet(isPresented: $showSellModal) {
            SellCryptoView()
        }
    }
}


// MARK: - Other Tab Views

struct IndexesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Crypto Indexes")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                IndexCard(name: "DeFi Index", value: "2,345.67", change: "+1.2%")
                IndexCard(name: "NFT Market Index", value: "785.32", change: "-0.5%")
                IndexCard(name: "Metaverse Index", value: "432.89", change: "+3.7%")
                IndexCard(name: "Layer 1 Index", value: "1,876.54", change: "+2.1%")
                
                Text("Historical Performance")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(Text("Index Performance Chart").foregroundColor(.white))
                    .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black)
    }
}

struct ManekiView: View {
    @State private var userMessage = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: 1, content: "Hi there! I'm Maneki, your crypto guide. How can I help you today?", isFromUser: false)
    ]
    
    var body: some View {
        VStack {
            Text("Maneki AI Assistant")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Ask Maneki anything...", text: $userMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(25)
                    .foregroundColor(.white)
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
        .background(Color.black)
    }
    
    func sendMessage() {
        guard !userMessage.isEmpty else { return }
        let newMsg = ChatMessage(id: messages.count + 1, content: userMessage, isFromUser: true)
        messages.append(newMsg)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let response = ChatMessage(id: messages.count + 1, content: "Based on current data, Bitcoin is showing a strong bullish pattern.", isFromUser: false)
            messages.append(response)
        }
        userMessage = ""
    }
}

struct PortfolioView: View {
    // Stub asset data
    let assets = [
        Asset(name: "Bitcoin", symbol: "BTC", amount: 0.0, value: 0.0)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Portfolio")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                if assets.isEmpty || assets[0].amount == 0.0 {
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
                    VStack(spacing: 15) {
                        Text("Total Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("$0.00")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.white)
                        HStack {
                            Text("+$0.00")
                                .font(.headline)
                                .foregroundColor(.green)
                            Text("(0.00%)")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Text("Your Assets")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    ForEach(assets) { asset in
                        AssetRow(asset: asset)
                    }
                }
                Spacer()
            }
        }
        .background(Color.black)
    }
}

struct DegenView: View {
    @Binding var isEnabled: Bool
    
    var body: some View {
        VStack {
            if isEnabled {
                Text("DEGEN MODE ACTIVE")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding(.top, 20)
                
                Text("High-risk trading enabled")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    DegenTradingCard(title: "Leverage Trading", description: "Trade with up to 100x leverage")
                    DegenTradingCard(title: "Options Trading", description: "Advanced derivatives market")
                    DegenTradingCard(title: "Futures", description: "Perpetual contracts with high liquidity")
                    DegenTradingCard(title: "Flash Loans", description: "DeFi protocol flash loans")
                }
//                .padding()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 60, height: 80)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                    
                    Text("Degen Mode Disabled")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Enable Degen Mode from the sidebar to access advanced high-risk trading features.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                    
                    Button(action: { isEnabled = true }) {
                        Text("Enable Degen Mode")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Modal Views for Trading

struct BuyCryptoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin = "Bitcoin"
    @State private var amount = ""
    @State private var paymentMethod = "Custodial Wallet"
    
    let coins = ["Bitcoin", "Ethereum", "Solana"]
    let paymentMethods = ["Custodial Wallet", "Apple Pay", "Bank Transfer"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Buy Cryptocurrency")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                VStack(alignment: .leading) {
                    Text("Select Coin")
                        .foregroundColor(.gray)
                    Picker("Coin", selection: $selectedCoin) {
                        ForEach(coins, id: \.self) { coin in
                            Text(coin).tag(coin)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Enter Amount")
                        .foregroundColor(.gray)
                    HStack {
                        Text("$")
                            .foregroundColor(.white)
                            .font(.title)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("Payment Method")
                        .foregroundColor(.gray)
                    Picker("Payment Method", selection: $paymentMethod) {
                        ForEach(paymentMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    // Process purchase action
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Confirm Purchase")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 30)
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

struct SellCryptoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCoin = "No Assets"
    @State private var amount = ""
    @State private var depositMethod = "Custodial Wallet"
    
    // Stub for available assets
    let availableCoins = ["No Assets"]
    let depositMethods = ["Custodial Wallet", "Bank Account"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Text("Sell Cryptocurrency")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                if availableCoins == ["No Assets"] {
                    VStack(spacing: 20) {
                        Image(systemName: "wallet.pass")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(.gray)
                        Text("No Assets Available")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("You don't have any crypto assets to sell at the moment. Purchase some first!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    .padding(40)
                } else {
                    VStack(alignment: .leading) {
                        Text("Select Asset")
                            .foregroundColor(.gray)
                        Picker("Asset", selection: $selectedCoin) {
                            ForEach(availableCoins, id: \.self) { coin in
                                Text(coin).tag(coin)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("Enter Amount")
                            .foregroundColor(.gray)
                        HStack {
                            Text("$")
                                .foregroundColor(.white)
                                .font(.title)
                            TextField("0.00", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("Deposit To")
                            .foregroundColor(.gray)
                        Picker("Deposit Method", selection: $depositMethod) {
                            ForEach(depositMethods, id: \.self) { method in
                                Text(method).tag(method)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                }
            }
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Additional Views & Support Components

struct ManekiIntroView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                HStack {
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                Image(systemName: "cat.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                Text("Welcome to Maneki!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Maneki is here to guide you through using Fortune Collective. Ask questions about market trends, portfolio tips, or get crypto insights.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
        .background(Color.black)
    }
}

struct ChatroomView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Text("Chatroom")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                Text("This feature is coming soon!")
                    .foregroundColor(.gray)
                Spacer()
            }
            .background(Color.black)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
            })
        }
        .preferredColorScheme(.dark)
    }
}

struct CommunityHubView: View {
    var body: some View {
        VStack {
            Text("Community Hub")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Connect with other crypto enthusiasts!")
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.black)
    }
}

struct NewsletterView: View {
    var body: some View {
        VStack {
            Text("Newsletter")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            Text("Subscribe for the latest crypto updates.")
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.black)
    }
}

struct MembershipApplication: Codable {
    let name: String
    let email: String
    let surveyResponses: [String: AnyCodable] // adapt based on your survey structure
}

// helper type to wrap values; see anycodable from github
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    // Simple implementation for String values
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let str = value as? String {
            try container.encode(str)
        } else {
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable only supports String in this example.")
            throw EncodingError.invalidValue(value, context)
        }
    }
}

struct ReserveView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Form Fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var emailConfirm: String = ""
    @State private var discord: String = ""
    @State private var instagramLink: String = ""
    @State private var instagramConfirm: String = ""
    @State private var ageGroup: String = ""
    @State private var occupation: String = ""
    @State private var whyFit: String = ""
    @State private var goals: String = ""
    @State private var cryptoExperience: String = ""
    @State private var startingCapital: String = ""
    @State private var agreedToTerms: Bool = false
    
    @State private var showConfirmationPopup = false
    @State private var validationErrors: [String: Bool] = [:]
    
    let fieldIDs = [
        "name", "email", "emailConfirm", "discord",
        "instagramLink", "instagramConfirm", "ageGroup",
        "occupation", "whyFit", "goals", "cryptoExperience",
        "startingCapital"
    ]
    .map { ($0, UUID()) }
    .reduce(into: [String: UUID]()) { $0[$1.0] = $1.1 }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reserve your membership.")
                                .font(.custom("Inter", size: 26))
                                .foregroundColor(.white)
                                .bold()
                            Text("7 simple answers.")
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        // Contact Info
                        Group {
                            Text("Provide your contact information.")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Enter your name", text: $name)
                                .id(fieldIDs["name"])
                            showError("name")
                            CustomTextField(placeholder: "Enter your email", text: $email)
                                .id(fieldIDs["email"])
                            showError("email")
                            CustomTextField(placeholder: "Confirm your email", text: $emailConfirm)
                                .id(fieldIDs["emailConfirm"])
                            showError("emailConfirm")
                            CustomTextField(placeholder: "Enter your Discord", text: $discord)
                                .id(fieldIDs["discord"])
                            showError("discord")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("1. What is your Instagram handle?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Paste your profile link", text: $instagramLink)
                                .id(fieldIDs["instagramLink"])
                            showError("instagramLink")
                            CustomTextField(placeholder: "Confirm your Instagram", text: $instagramConfirm)
                                .id(fieldIDs["instagramConfirm"])
                            showError("instagramConfirm")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("2. What is your age group?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            AgeGroupRadioGroup(selectedAgeGroup: $ageGroup)
                                .id(fieldIDs["ageGroup"])
                            showError("ageGroup")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("3. What do you do for work?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextField(placeholder: "Enter your occupation", text: $occupation)
                                .id(fieldIDs["occupation"])
                            showError("occupation")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("4. Why do you think you're a great fit for Fortune Collective?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextEditor(placeholder: "Enter your message here", text: $whyFit)
                                .id(fieldIDs["whyFit"])
                            showError("whyFit")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("5. Share a bit about your goals, what drives you, and what makes you determined to succeed:")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CustomTextEditor(placeholder: "Enter your message here", text: $goals)
                                .id(fieldIDs["goals"])
                            showError("goals")
                            Text("We accept fewer than 18% of applicants. Show us why you deserve to join Fortune Collective. The more effort you put in, the better your chances.")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("6. How much crypto experience do you have?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            CryptoExperiencePicker(experience: $cryptoExperience)
                                .id(fieldIDs["cryptoExperience"])
                            showError("cryptoExperience")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        Group {
                            Text("7. How much is your starting capital?")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            StartingCapitalRadioGroup(selectedCapital: $startingCapital)
                                .id(fieldIDs["startingCapital"])
                            showError("startingCapital")
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                            .padding(.vertical, 20)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Acknowledgment")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .bold()
                            Text("Admission to Fortune Collective is NOT free. By applying, you confirm that you’re ready to invest in connecting with 7-figure crypto traders and accessing top-tier strategies.")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                            Toggle(isOn: $agreedToTerms) {
                                HStack {
                                    Text("Agree to our ")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                    Button {
                                        // Link to TOS if needed
                                    } label: {
                                        Text("TOS & Privacy Policy.")
                                            .foregroundColor(.gray)
                                            .underline()
                                            .font(.system(size: 14))
                                    }
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            validateFields(proxy: proxy)
                        }) {
                            Text("Apply")
                                .font(.custom("Inter", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(agreedToTerms ? Color.white.opacity(0.1) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .disabled(!agreedToTerms)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            
            if showConfirmationPopup {
                Color.black.opacity(0.75).edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Text("Thank you for completing your application.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Return to Home")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.2).cornerRadius(8))
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.9))
                )
                .padding(.horizontal, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func validateFields(proxy: ScrollViewProxy) {
        let orderedFields: [(key: String, value: String)] = [
            ("name", name),
            ("email", email),
            ("emailConfirm", emailConfirm),
            ("discord", discord),
            ("instagramLink", instagramLink),
            ("instagramConfirm", instagramConfirm),
            ("ageGroup", ageGroup),
            ("occupation", occupation),
            ("whyFit", whyFit),
            ("goals", goals),
            ("cryptoExperience", cryptoExperience),
            ("startingCapital", startingCapital)
        ]
        
        var errors = [String: Bool]()
        var firstErrorField: String?
        
        for field in orderedFields {
            let isEmpty = field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            errors[field.key] = isEmpty
            if isEmpty, firstErrorField == nil {
                firstErrorField = field.key
            }
        }
        
        validationErrors = errors
        
        if let field = firstErrorField, let fieldID = fieldIDs[field] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    proxy.scrollTo(fieldID, anchor: .top)
                }
            }
        } else {
            // All fields are valid—build the survey data and call submitApplication
            let surveyResponses: [String: AnyCodable] = [
                "discord": AnyCodable(discord),
                "instagramLink": AnyCodable(instagramLink),
                "instagramConfirm": AnyCodable(instagramConfirm),
                "ageGroup": AnyCodable(ageGroup),
                "occupation": AnyCodable(occupation),
                "whyFit": AnyCodable(whyFit),
                "goals": AnyCodable(goals),
                "cryptoExperience": AnyCodable(cryptoExperience),
                "startingCapital": AnyCodable(startingCapital)
            ]
            
            let application = MembershipApplication(name: name, email: email, surveyResponses: surveyResponses)
            submitApplication(application) { success in
                if success {
                    // On success, display the confirmation popup.
                    DispatchQueue.main.async {
                        showConfirmationPopup = true
                    }
                } else {
                    // Handle failure (e.g. show an error alert to the user)
                    print("Submission failed")
                }
            }
        }
    }
    
    // Submits the application data to the backend
    func submitApplication(_ application: MembershipApplication, completion: @escaping (Bool) -> Void) {
        let formSubmitURL = "https://formsubmit.co/rayconghou@gmail.com" // Replace with your FormSubmit link
        var request = URLRequest(url: URL(string: formSubmitURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = [
            "name": application.name,
            "email": application.email,
            "message": "Why Fit: \(application.surveyResponses["whyFit"]?.value ?? "Not provided")"
        ]
        .map { "\($0.key)=\($0.value)" }
        .joined(separator: "&")
        .data(using: .utf8)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting form: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }.resume()
    }

    
    @ViewBuilder
    private func showError(_ field: String) -> some View {
        if validationErrors[field] ?? false {
            Text("This field is required.")
                .foregroundColor(.red)
                .font(.custom("Inter", size: 14))
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.custom("Inter", size: 16))
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
            )
    }
}

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.custom("Inter", size: 16))
                .frame(minHeight: 100)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.custom("Inter", size: 16))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .allowsHitTesting(false)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct AgeGroupRadioGroup: View {
    @Binding var selectedAgeGroup: String
    let options = ["Under 18", "18-24", "25-33", "33+"]
    var body: some View {
        HStack {
            ForEach(options, id: \.self) { age in
                HStack {
                    Circle()
                        .fill(selectedAgeGroup == age ? Color.white : Color.clear)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: 20, height: 20)
                        .onTapGesture { selectedAgeGroup = age }
                    Text(age)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
    }
}

struct CryptoExperiencePicker: View {
    @Binding var experience: String
    let options = [
        "I'm a beginner looking to get started with crypto",
        "I have some experience",
        "I'm quite experienced",
        "I'm a professional trader"
    ]
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) { experience = option }
            }
        } label: {
            HStack {
                Text(experience.isEmpty ? "Select your experience level" : experience)
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 16))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

struct StartingCapitalRadioGroup: View {
    @Binding var selectedCapital: String
    let options = [
        "$0-$999",
        "$1,000-$9,999",
        "$10,000-$49,999",
        "$50,000-$99,999",
        "$100,000+"
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(options, id: \.self) { capital in
                HStack {
                    Circle()
                        .fill(selectedCapital == capital ? Color.white : Color.clear)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: 20, height: 20)
                        .onTapGesture { selectedCapital = capital }
                    Text(capital)
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.white)
                }
            }
        }
    }
}



// MARK: - Support Views

struct CryptoTrendCard: View {
    let name: String
    let symbol: String
    let price: Double
    /// This is the 24h change in percent (e.g. -3.12 means -3.12%)
    let change: Double
    
    var body: some View {
        // Decide if it’s positive or negative
        let isPositive = change >= 0
        // Format the numeric change to a percentage string
        let changeString = String(format: "%.2f%%", change)
        
        HStack {
            // Left section: name + symbol
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(symbol)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Right section: price + 24h change with icon
            VStack(alignment: .trailing) {
                // Current price formatted as currency:
                Text(price.asCurrency)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    // Icon: arrow up or down
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .resizable()
                        .foregroundColor(isPositive ? .green : .red)
                        .frame(width: 10, height: 10)
                    
                    // The text “+1.23%” or “-2.34%”
                    Text(changeString)
                        .font(.subheadline)
                        .foregroundColor(isPositive ? .green : .red)
                        .padding(.leading, 5)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NewsCard: View {
    let title: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            Text(time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct IndexCard: View {
    let name: String
    let value: String
    let change: String
    
    var isPositive: Bool {
        return change.contains("+")
    }
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .trailing) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(change)
                    .font(.subheadline)
                    .foregroundColor(isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct DegenTradingCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                // Action for trading option
            }) {
                Text("Start Trading")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .frame(height: 90)
        .frame(minWidth: 300)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct Asset: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let amount: Double
    let value: Double
}

struct AssetRow: View {
    let asset: Asset
    var body: some View {
        HStack {
            Text(asset.name)
                .foregroundColor(.white)
            Spacer()
            Text("\(asset.amount, specifier: "%.4f") \(asset.symbol)")
                .foregroundColor(.gray)
            Text("$\(asset.value, specifier: "%.2f")")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ChatMessage: Identifiable {
    let id: Int
    let content: String
    let isFromUser: Bool
}

struct ChatBubble: View {
    let message: ChatMessage
    var body: some View {
        HStack {
            if message.isFromUser { Spacer() }
            Text(message.content)
                .padding()
                .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(18)
                .frame(maxWidth: 280, alignment: message.isFromUser ? .trailing : .leading)
            if !message.isFromUser { Spacer() }
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
