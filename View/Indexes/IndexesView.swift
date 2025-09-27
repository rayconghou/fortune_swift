import Foundation
import SwiftUI

// MARK: - Main Index View
struct IndexesView: View {
    var hamburgerAction: () -> Void
    @State private var selectedTab: IndexSourceTab = .teamPicks
    @StateObject private var viewModel = LeaderboardViewModel()
    @State private var showManekiQuizModal = false
    @State private var showCreateIndexSheet = false
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background color
            Color(hex: "050715")
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // TopBar with profile, search, notifications, and hamburger menu
                TopBar(
                    searchText: $searchText,
                    onHamburgerTap: hamburgerAction,
                    onNotificationTap: {
                        // TODO: Implement notification action
                        print("Notification tapped")
                    },
                    onProfileTap: {
                        // TODO: Implement profile action
                        print("Profile tapped")
                    }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with title and create button
                        headerSection
                        
                        // My Indexes section
                        myIndexesSection
                        
                        // Tab Selection
                        tabSelectionSection
                        
                        // Content based on selected tab
                        contentSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            
            // Programmatic overlay effect - no asset imports, no layout breaking
            GeometryReader { geometry in
                ZStack {
                    // Subtle radial gradient overlay
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.03),
                            Color.blue.opacity(0.01),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 50,
                        endRadius: 300
                    )
                    .ignoresSafeArea(.all)
                    
                    // Additional subtle pattern overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.015),
                            Color.clear
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(.all)
                }
            }
            .allowsHitTesting(false)
        }
        .sheet(isPresented: $showManekiQuizModal) {
            ManekiQuizModalView()
        }
        .sheet(isPresented: $showCreateIndexSheet) {
            CreateIndexView(
                selectedTab: $selectedTab,
                leaderboardVM: viewModel,
                isPresented: $showCreateIndexSheet
            )
        }
    }
    
    // MARK: - UI Components
    
    private var headerSection: some View {
        HStack {
            Text("Indexes")
                .font(.custom("Satoshi-Bold", size: 32))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                showCreateIndexSheet = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Create Index")
                        .font(.custom("Satoshi-Bold", size: 16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "141628"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.top, 20)
    }
    
    private var myIndexesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Indexes")
                .font(.custom("Satoshi-Bold", size: 20))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // AI James Select (Positive)
                MyIndexCard(
                    profileImage: "Profile",
                    indexName: "AI James Select",
                    creator: "by @jameswang",
                    value: "$12.23",
                    change: "▲ 1,12%",
                    isPositive: true
                )
                
                // AI James Select (Negative)
                MyIndexCard(
                    profileImage: "User",
                    indexName: "AI James Select",
                    creator: "by @jameswang",
                    value: "$117 176,16",
                    change: "▼ 1,12%",
                    isPositive: false
                )
            }
        }
    }
    
    private var tabSelectionSection: some View {
        HStack(spacing: 4) {
            ForEach(IndexSourceTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.custom("Satoshi-Bold", size: 14))
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background(
                            selectedTab == tab ?
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.5, blue: 1.0),      // Bright blue
                                    Color(red: 0.1, green: 0.3, blue: 0.8)       // Darker blue
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) : LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 12)
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            switch selectedTab {
            case .teamPicks:
                teamPicksContent
            case .manekiQuiz:
                manekiQuizContent
            case .community:
                communityContent
            }
        }
    }
    
    private var teamPicksContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommended For You")
                .font(.custom("Satoshi-Bold", size: 20))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // Income Builder
                RecommendedIndexCard(
                    indexName: "Income Builder",
                    value: "$1 428,67",
                    change: "-$705,70 ▼ 1,32% • Today",
                    isPositive: false
                )
                
                // Growth Portfolio
                RecommendedIndexCard(
                    indexName: "Growth Portfolio",
                    value: "$785,32",
                    change: "+$293,70 ▲ 1,32% • Today",
                    isPositive: true
                )
                
                // Balanced Strategy
                RecommendedIndexCard(
                    indexName: "Balanced Strategy",
                    value: "$2 432.89",
                    change: "+$293,70 ▲ 1,32% • Today",
                    isPositive: true
                )
            }
        }
    }
    
    private var manekiQuizContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                showManekiQuizModal = true
            }) {
                HStack {
                    Image("SealQuestion")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Take Maneki's Investment Quiz")
                        .font(.custom("Satoshi-Bold", size: 18))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                )
            }
        }
    }
    
    private var communityContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Leaderboard")
                .font(.custom("Satoshi-Bold", size: 20))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // Community Index 1
                CommunityIndexCard(
                    rank: 1,
                    indexName: "Community Index 1",
                    creator: "by @dojouser123",
                    roi: "▲ 24.8% ROI"
                )
                
                // Community Index 2
                CommunityIndexCard(
                    rank: 2,
                    indexName: "Community Index 2",
                    creator: "by @dojouser123",
                    roi: "▲ 22.3% ROI"
                )
                
                // Community Index 3
                CommunityIndexCard(
                    rank: 3,
                    indexName: "Community Index 3",
                    creator: "by @dojouser123",
                    roi: "▲ 19.7% ROI"
                )
                
                // Community Index 4
                CommunityIndexCard(
                    rank: 4,
                    indexName: "Community Index 4",
                    creator: "by @dojouser123",
                    roi: "▲ 16.2% ROI"
                )
                
                // Community Index 5
                CommunityIndexCard(
                    rank: 5,
                    indexName: "Community Index 5",
                    creator: "by @dojouser123",
                    roi: "▲ 15.1% ROI"
                )
            }
        }
    }
}

// MARK: - Index Source Tab Enum
enum IndexSourceTab: String, CaseIterable {
    case teamPicks = "Team Picks"
    case manekiQuiz = "Maneki Quiz"
    case community = "Community"
}

// MARK: - My Index Card Component
struct MyIndexCard: View {
    let profileImage: String
    let indexName: String
    let creator: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile image
            if profileImage == "User" {
                Image(profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "272A45"))
                    )
            } else {
                Image(profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(indexName)
                    .font(.custom("Satoshi-Bold", size: 16))
                    .foregroundColor(.white)
                
                Text(creator)
                    .font(.custom("Satoshi-Bold", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(value)
                    .font(.custom("Satoshi-Bold", size: 16))
                    .foregroundColor(.white)
                
                Text(change)
                    .font(.custom("Satoshi-Bold", size: 14))
                    .foregroundColor(isPositive ? .green : .red)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color(hex: "141628"))
        .cornerRadius(12)
    }
}

// MARK: - Team Index Card Component
struct TeamIndexCard: View {
    let indexName: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(indexName)
                        .font(.custom("Satoshi-Bold", size: 16))
                        .foregroundColor(.white)
                    
                    Text(value)
                        .font(.custom("Satoshi-Bold", size: 24))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Text(change.components(separatedBy: " • ").first ?? change)
                            .font(.custom("Satoshi-Bold", size: 14))
                            .foregroundColor(isPositive ? .green : .red)
                        
                        if change.contains("•") {
                            Text("• Today")
                                .font(.custom("Satoshi-Bold", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // Sparkline Chart with extrapolation
            SparklineChartView(data: generateMockSparklineData(), isPositive: isPositive)
                .frame(height: 60)
        }
        .padding(16)
        .background(Color(hex: "141628"))
        .cornerRadius(12)
    }
    
    // Helper function to generate mock sparkline data
    private func generateMockSparklineData() -> [Double] {
        // Generate more data points for better chart coverage
        let dataPoints = 50
        var data: [Double] = []
        var currentValue = Double.random(in: 20...80)
        
        for i in 0..<dataPoints {
            // Create a more realistic trend with some randomness
            let trend = isPositive ? 0.5 : -0.3
            let randomChange = Double.random(in: -2...2)
            currentValue += trend + randomChange
            currentValue = max(0, min(100, currentValue)) // Keep within bounds
            data.append(currentValue)
        }
        
        return data
    }
}

// MARK: - Community Index Card Component
struct CommunityIndexCard: View {
    let rank: Int
    let indexName: String
    let creator: String
    let roi: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank number
            Text("#\(rank)")
                .font(.custom("Satoshi-Bold", size: 16))
                .foregroundColor(.white)
                .frame(width: 30, alignment: .leading)
            
            // Profile icon
            Image(systemName: "person.circle")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(indexName)
                    .font(.custom("Satoshi-Bold", size: 14))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(creator)
                    .font(.custom("Satoshi-Bold", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(roi)
                    .font(.custom("Satoshi-Bold", size: 14))
                    .foregroundColor(.green)
                    .lineLimit(1)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color(hex: "141628"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Recommended Index Card Component
struct RecommendedIndexCard: View {
    let indexName: String
    let value: String
    let change: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(indexName)
                        .font(.custom("Satoshi-Bold", size: 16))
                        .foregroundColor(.white)
                    
                    Text(value)
                        .font(.custom("Satoshi-Bold", size: 24))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Text(change.components(separatedBy: " • ").first ?? change)
                            .font(.custom("Satoshi-Bold", size: 14))
                            .foregroundColor(isPositive ? .green : .red)
                        
                        if change.contains("•") {
                            Text("• Today")
                                .font(.custom("Satoshi-Bold", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            // Sparkline Chart with extrapolation
            SparklineChartView(data: generateMockSparklineData(), isPositive: isPositive)
                .frame(height: 60)
        }
        .padding(16)
        .background(Color(hex: "141628"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // Helper function to generate mock sparkline data
    private func generateMockSparklineData() -> [Double] {
        // Generate more data points for better chart coverage
        let dataPoints = 50
        var data: [Double] = []
        var currentValue = Double.random(in: 20...80)
        
        for i in 0..<dataPoints {
            // Create a more realistic trend with some randomness
            let trend = isPositive ? 0.5 : -0.3
            let randomChange = Double.random(in: -2...2)
            currentValue += trend + randomChange
            currentValue = max(0, min(100, currentValue)) // Keep within bounds
            data.append(currentValue)
        }
        
        return data
    }
}


// MARK: - Community Indexes Tab
struct CommunityIndexesView: View {
    @State private var selectedTimeFrame: TimeFrame = .month
    @Binding var showCreateIndexSheet: Bool
    @ObservedObject var viewModel: LeaderboardViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Leaderboard")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                TimeFrameSelector(selected: $selectedTimeFrame)
            }
            .padding(.top, 8)
            
            // Leaderboard Header
            HStack {
                Text("Rank")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 40, alignment: .leading)
                
                Text("Index Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("ROI")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .trailing)
                
                Text("Creator")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .trailing)
            }
            .padding(.horizontal, 8)
            
            Text("Leaderboard count: \(viewModel.leaderboard.count)")
                .foregroundColor(.green)
            
            ForEach(Array(viewModel.leaderboard.prefix(5).enumerated()), id: \.element.id) { index, item in
                LeaderboardItem(
                    rank: index + 1,
                    name: item.index_name,
                    roi: item.formattedROI,
                    creator: item.creator
                )
            }
            
            Button(action: {
                showCreateIndexSheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Your Own Index")
                    Spacer()
                    Text("+20% Token Rewards")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.tertiarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
            }
            .foregroundColor(.primary)
            .padding(.top, 8)
            
            Spacer(minLength: 50)
        }
        .onAppear {
            print("community indexes appeard")
            viewModel.fetchLeaderboard()
        }
    }
}

// Time frame for leaderboard
enum TimeFrame: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct TimeFrameSelector: View {
    @Binding var selected: TimeFrame
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                Button(action: {
                    selected = timeFrame
                }) {
                    Text(timeFrame.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(selected == timeFrame ? Color.accentColor : Color.clear)
                        )
                        .foregroundColor(selected == timeFrame ? .white : .secondary)
                }
            }
        }
        .background(
            Capsule()
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
}

struct LeaderboardItem: View {
    var rank: Int
    var name: String
    var roi: String
    var creator: String
    
    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.subheadline)
                .foregroundColor(rank <= 3 ? .yellow : .secondary)
                .fontWeight(rank <= 3 ? .bold : .regular)
                .frame(width: 40, alignment: .leading)
            
            Text(name)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(roi)
                .font(.subheadline)
                .foregroundColor(.green)
                .frame(width: 80, alignment: .trailing)
            
            Text("@\(creator)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .trailing)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

struct LeaderboardIndex: Codable, Identifiable {
    var id: UUID { UUID() } // ← This makes a random UUID for each row
    let index_name: String
    let roi: Double
    let creator: String

    var formattedROI: String {
        String(format: roi >= 0 ? "+%.1f%%" : "%.1f%%", roi)
    }
}

class LeaderboardViewModel: ObservableObject {
    @Published var leaderboard: [LeaderboardIndex] = []

    func fetchLeaderboard() {
        print("🔍 Attempting to fetch leaderboard...")

        // For now, use mock data to avoid network issues
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.leaderboard = [
                LeaderboardIndex(index_name: "AI Memes Index", roi: 15.2, creator: "jameswang"),
                LeaderboardIndex(index_name: "Fortune AI Select", roi: 12.8, creator: "alexchen"),
                LeaderboardIndex(index_name: "AI Blue Chips", roi: 8.5, creator: "sarahkim")
            ]
            print("✅ Mock leaderboard data loaded")
        }
    }
}



// MARK: - Maneki Quiz Modal
struct ManekiQuizModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestion = 0
    @State private var selectedAnswers: [Int] = []
    
    let questions = [
        "Whats your investment time horizon?",
        "How would you react to a 20% market drop?",
        "What's your primary investment goal?"
    ]
    
    let answers = [
        ["Short Term (< 1 year)", "Medium Term (1-5 years)", "Long Term (5+ years)"],
        ["Sell Immediately", "Hold and Wait", "Buy More"],
        ["Capital preservation", "Balanced growth", "Maximum returns"]
    ]
    
    var body: some View {
        ZStack {
            // Background color
            Color(hex: "050715")
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with back button and title
                HStack {
                    Button(action: {
                        if currentQuestion > 0 {
                            currentQuestion -= 1
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Title and question counter
                VStack(alignment: .leading, spacing: 8) {
                    Text("Maneki's Investment Quiz")
                        .font(.custom("Satoshi-Bold", size: 24))
                        .foregroundColor(.white)
                    
                    Text("Question \(currentQuestion + 1) of \(questions.count)")
                        .font(.custom("Satoshi-Bold", size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if currentQuestion < questions.count {
                    // Question content
                    VStack(alignment: .leading, spacing: 24) {
                        Text(questions[currentQuestion])
                            .font(.custom("Satoshi-Bold", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        VStack(spacing: 16) {
                            ForEach(0..<answers[currentQuestion].count, id: \.self) { index in
                                QuizAnswerButton(
                                    text: answers[currentQuestion][index],
                                    isSelected: selectedAnswers.count > currentQuestion && selectedAnswers[currentQuestion] == index,
                                    action: {
                                        if selectedAnswers.count > currentQuestion {
                                            selectedAnswers[currentQuestion] = index
                                        } else {
                                            selectedAnswers.append(index)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Navigation button
                    Button(action: {
                        if currentQuestion < questions.count - 1 {
                            currentQuestion += 1
                        } else {
                            // Show results or finish
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text(currentQuestion < questions.count - 1 ? "Next Question" : "Finish Quiz")
                            .font(.custom("Satoshi-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Progress indicator
                    HStack(spacing: 8) {
                        ForEach(0..<questions.count, id: \.self) { index in
                            Rectangle()
                                .fill(index <= currentQuestion ? Color.white : Color.gray.opacity(0.3))
                                .frame(height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                } else {
                    // Results view
                    VStack(spacing: 24) {
                        Text("Your Recommended Portfolio:")
                            .font(.custom("Satoshi-Bold", size: 20))
                            .foregroundColor(.white)
                        
                        RecommendedIndexCard(
                            indexName: "Balanced Growth Portfolio",
                            value: "1,247.38",
                            change: "+2.3% • Today",
                            isPositive: true
                        )
                        
                        Text("This portfolio matches your risk tolerance and time horizon.")
                            .font(.custom("Satoshi-Bold", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Apply This Portfolio")
                                .font(.custom("Satoshi-Bold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue)
                                )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Quiz Answer Button Component
struct QuizAnswerButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.custom("Satoshi-Bold", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Radio button
                Circle()
                    .fill(isSelected ? Color.white : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "141628"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Preview
struct IndexesView_Previews: PreviewProvider {
    static var previews: some View {
        IndexesView(hamburgerAction: {})
            .preferredColorScheme(.dark)
    }
}
