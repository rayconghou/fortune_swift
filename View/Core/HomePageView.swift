import Foundation
import SwiftUI

struct HomePageView: View {
    @State private var showSidebar = false
    @State private var hideHamburger = false
    @State private var showDegenMode = false
    @State private var showDegenExitConfirmation = false
    @State private var degenEntryTabTag = 98
    @State private var degenExitTabTag = 99
    @State private var showManekiButton = true
    @State private var hideSplashScreen = false
    @State private var isDegenSplashActive = false
    @State private var isExitingSplashActive = false
    @State private var showFortune = false
    @State private var showCollective = false
    @State private var showBottomElements = false
    @StateObject private var userProfile = UserProfileViewModel()
    @StateObject private var tradingWalletViewModel = TradingWalletViewModel()
    @State private var selectedTab: Int = 0
    
    // Enum to represent different app modes
    enum AppMode {
        case standard
        case degen
    }
    
    @State private var currentMode: AppMode = .standard
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Dynamically choose tabs based on current mode
                switch currentMode {
                case .standard:
                    standardModeTabs
                case .degen:
                    degenModeTabs
                }
            }
            .disabled(showSidebar || isDegenSplashActive || isExitingSplashActive)
            
            // Existing Sidebar View
            SidebarView(
                showSidebar: $showSidebar,
                showDegenMode: $showDegenMode,
                selectedTab: $selectedTab,
                userProfile: userProfile
            )
            .frame(width: UIScreen.main.bounds.width)
            .offset(x: showSidebar ? 0 : -UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.3), value: showSidebar)
            
            // Hamburger Menu
            if !hideHamburger {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                .padding(.leading, 15)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 25)
                .padding(.leading, 5)
                .transition(.opacity)
            }
            
            if showDegenExitConfirmation {
                Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)

                VStack(spacing: 20) {
                    Text("Leave Degen Mode?")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)

                    Text("You’re about to exit Degen Mode and return to the standard app.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    HStack(spacing: 16) {
                        Button(action: {
                            // Cancel — stay in degen mode
                            showDegenExitConfirmation = false
                        }) {
                            Text("Cancel")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            showDegenExitConfirmation = false
                            
                            // Prepare for exit before showing the splash
                            selectedTab = 0
                            
                            // Activate exit splash first
                            activateExitSplash()
                            
                            // Close sidebar silently in the background
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                showSidebar = false
                            }
                            
                            currentMode = .standard
                            showDegenMode = false
                        }) {
                            Text("Confirm")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                }
                .padding()
                .background(Color(hex: "171D2B"))
                .cornerRadius(20)
                .padding(.horizontal, 40)
                .transition(.scale)
                .zIndex(999)
            }
            
            // Degen Mode Splash Screen
            if isDegenSplashActive {
                DegenSplashScreen()
                    .offset(y: hideSplashScreen ? -UIScreen.main.bounds.height : 0)
                    .animation(.easeInOut(duration: 1.5).delay(0.75), value: hideSplashScreen)
                    .ignoresSafeArea()
            }
            
            // Exit Splash Screen (using original splash screen logic)
            if isExitingSplashActive {
                exitSplashScreen
                    .offset(y: hideSplashScreen ? -UIScreen.main.bounds.height : 0)
                    .animation(.easeInOut(duration: 1.5).delay(0.75), value: hideSplashScreen)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: showSidebar) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.7)) {
                hideHamburger = newValue
            }
        }
        .onChange(of: showDegenMode) { oldValue, newValue in
            if newValue {
                activateDegenSplash()
                currentMode = .degen
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if currentMode == .degen && newValue == degenExitTabTag {
                selectedTab = oldValue
                requestExitDegenMode()
            } else if currentMode == .standard && newValue == degenEntryTabTag {
                selectedTab = oldValue
                activateDegenSplash()
            }
        }
    }
    
    // Exit Splash Screen View
    private var exitSplashScreen: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("FORTUNE")
                    .foregroundColor(.white)
                    .font(.custom("Inter", size: 48))
                    .opacity(showFortune ? 1 : 0)
                    .animation(.easeIn(duration: 0.1).delay(0.3), value: showFortune)
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
    
    // Standard Mode Tabs (previous implementation)
    private var standardModeTabs: some View {
        Group {
            SpotView(hideHamburger: $hideHamburger)
                .tag(0)
                .tabItem {
                    Image(systemName: "binoculars.fill")
                }
            
            IndexesView()
                .tag(1)
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                }
            
            ManekiView()
                .tag(2)
                .tabItem {
                    Image(systemName: "cat.fill")
                        .font(.system(size: 28))
                }
            
            PortfolioView()
                .tag(3)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                }
            
            Color.clear
                .tag(degenEntryTabTag)
                .tabItem {
                    Image(systemName: "flame.fill")
                }
        }
    }
    
    // Degen Mode Tabs (previous implementation)
    private var degenModeTabs: some View {
        Group {
            DegenTrendingView()
                .tag(0)
                .tabItem {
                    Image(systemName: "flame")
                }
            
            WalletSocialMediaTrackerView()
                .tag(1)
                .tabItem {
                    Image(systemName: "wallet.pass")
                }
                .environmentObject(tradingWalletViewModel)
            
            DegenTradeView()
                .tag(2)
                .tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            
            PortfolioView()
                .tag(3)
                .tabItem {
                    Image(systemName: "briefcase")
                }
            
            //TODO: create another toggle feature for turning off degen modew when in degen mode, it will cause a modal warning pop to appear, asking the user to confirm leaving degen mode, would turn off degen mode
            Color.clear
                .tag(degenExitTabTag)
                .tabItem {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            
        }
    }
    
    private func requestExitDegenMode() {
        if !showDegenExitConfirmation {
            showDegenExitConfirmation = true
        }
    }
    
    // Existing activation method for Degen Splash
    private func activateDegenSplash() {
        isDegenSplashActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showDegenMode = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                hideSplashScreen = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isDegenSplashActive = false
            hideSplashScreen = false
        }
    }
    
    // New method for Exit Splash
    private func activateExitSplash() {
        isExitingSplashActive = true
        
        // Replicate the original splash screen animation
        showFortune = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCollective = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showBottomElements = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                hideSplashScreen = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isExitingSplashActive = false
            hideSplashScreen = false
            showFortune = false
            showBottomElements = false
        }
    }
}

// Placeholder views for Degen Mode (you'll replace these with actual implementations)


struct DegenIndexesView: View {
    var body: some View {
        Text("Degen Crypto Indexes")
            .foregroundColor(.white)
    }
}

struct DegenPortfolioView: View {
    var body: some View {
        Text("Degen Portfolio")
            .foregroundColor(.white)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
