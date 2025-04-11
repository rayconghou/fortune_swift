import Foundation
import SwiftUI

struct HomePageView: View {
    @State private var showSidebar = false
    @State private var hideHamburger = false
    @State private var showDegenMode = false
    @State private var showDegenExitConfirmation = false
    @State private var showDegenEntryWarning = false // New state for entry warning
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
            .disabled(showSidebar || isDegenSplashActive || isExitingSplashActive || showDegenEntryWarning || showDegenExitConfirmation)
            
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
            
            // Overlay for Popups
            if showDegenExitConfirmation || showDegenEntryWarning {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            // Entry Warning Popup (New)
            if showDegenEntryWarning {
                DegenEntryWarningView(
                    isPresented: $showDegenEntryWarning,
                    onAccept: {
                        showDegenEntryWarning = false
                        
                        // Close sidebar silently in the background if open
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showSidebar = false
                        }
                        
                        // Activate degen splash animation and mode change
                        activateDegenSplash()
                    }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
                .zIndex(999)
            }
            
            // Exit Confirmation Popup (Updated)
            if showDegenExitConfirmation {
                DegenExitConfirmationView(
                    isPresented: $showDegenExitConfirmation,
                    onConfirm: {
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
                    }
                )
                .transition(.scale(scale: 0.9).combined(with: .opacity))
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
            if newValue && currentMode == .standard {
                // Instead of immediately activating, show the warning first
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showDegenEntryWarning = true
                }
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if currentMode == .degen && newValue == degenExitTabTag {
                selectedTab = oldValue
                requestExitDegenMode()
            } else if currentMode == .standard && newValue == degenEntryTabTag {
                selectedTab = oldValue
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showDegenEntryWarning = true
                }
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
    
    // Standard Mode Tabs
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
    
    // Degen Mode Tabs
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
            
            Color.clear
                .tag(degenExitTabTag)
                .tabItem {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
        }
    }
    
    private func requestExitDegenMode() {
        if !showDegenExitConfirmation {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showDegenExitConfirmation = true
            }
        }
    }
    
    // Existing activation method for Degen Splash
    private func activateDegenSplash() {
        isDegenSplashActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showDegenMode = true
            currentMode = .degen
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
    
    // Method for Exit Splash
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

// New Entry Warning View
struct DegenEntryWarningView: View {
    @Binding var isPresented: Bool
    var onAccept: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with icon
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.yellow)
                
                Text("DEGEN MODE")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.yellow)
            }
            .padding(.top, 6)
            
            // Warning
            Text("You're entering high-risk trading territory")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Risk information
            VStack(alignment: .leading, spacing: 12) {
                riskRow(icon: "chart.line.downtrend.xyaxis", text: "Higher market volatility")
                riskRow(icon: "bolt.fill", text: "Rapid price movements")
                riskRow(icon: "dollarsign.circle", text: "Potential for significant losses")
                riskRow(icon: "tornado", text: "Less regulated assets")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            
            // Risk acknowledgment text
            Text("By entering Degen Mode, you acknowledge that you understand these risks and are trading at your own discretion.")
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
            
            // Buttons
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "2D3042"), Color(hex: "1E2132")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        )
                        .cornerRadius(12)
                }
                
                Button(action: onAccept) {
                    Text("Accept Risk")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.orange.opacity(0.5), radius: 8, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 5)
        }
        .padding(24)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "171D2B"), Color(hex: "0D1018")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Subtle grid pattern
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let gridSize: CGFloat = 20
                        
                        for i in stride(from: 0, through: width, by: gridSize) {
                            path.move(to: CGPoint(x: i, y: 0))
                            path.addLine(to: CGPoint(x: i, y: height))
                        }
                        
                        for i in stride(from: 0, through: height, by: gridSize) {
                            path.move(to: CGPoint(x: 0, y: i))
                            path.addLine(to: CGPoint(x: width, y: i))
                        }
                    }
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.3), Color.clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(20)
        .shadow(color: Color.yellow.opacity(0.2), radius: 20, x: 0, y: 0)
        .padding(.horizontal, 24)
    }
    
    private func riskRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color.yellow)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

// Updated Exit Confirmation View
struct DegenExitConfirmationView: View {
    @Binding var isPresented: Bool
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Header with icon
            HStack {
                Image(systemName: "arrow.uturn.backward.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color.blue.opacity(0.9))
                
                Text("Exit Degen Mode")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 8)
            
            Divider()
                .background(LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.5), Color.clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            
            // Message
            Text("You're about to exit Degen Mode and return to the standard interface.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            // Additional info
            VStack(alignment: .leading, spacing: 8) {
                infoRow(icon: "checkmark.shield.fill", text: "Your portfolio data will remain intact")
                infoRow(icon: "arrow.2.squarepath", text: "You can return to Degen Mode anytime")
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(8)
            
            // Buttons
            HStack(spacing: 16) {
                Button(action: {
                    withAnimation(.spring()) {
                        isPresented = false
                    }
                }) {
                    Text("Stay")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "2D3042"), Color(hex: "1E2132")]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        )
                        .cornerRadius(12)
                }
                
                Button(action: onConfirm) {
                    Text("Confirm Exit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "3B82F6"), Color(hex: "2563EB")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 2)
                }
            }
        }
        .padding(24)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "171D2B"), Color(hex: "0D1018")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Subtle pattern
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let gridSize: CGFloat = 20
                        
                        for i in stride(from: 0, through: width, by: gridSize) {
                            path.move(to: CGPoint(x: i, y: 0))
                            path.addLine(to: CGPoint(x: i, y: height))
                        }
                        
                        for i in stride(from: 0, through: height, by: gridSize) {
                            path.move(to: CGPoint(x: 0, y: i))
                            path.addLine(to: CGPoint(x: width, y: i))
                        }
                    }
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.2), Color.clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(20)
        .shadow(color: Color.blue.opacity(0.15), radius: 20, x: 0, y: 0)
        .padding(.horizontal, 24)
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color.blue.opacity(0.9))
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
