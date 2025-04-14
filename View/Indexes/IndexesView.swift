import Foundation
import SwiftUI

// MARK: - Main Index View
struct IndexesView: View {
    var hamburgerAction: () -> Void
    @State private var selectedTab: IndexSourceTab = .handpicked
    @State private var showManekiQuizModal = false
    @State private var showCreateIndexSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab Selection
                IndexSourceTabView(selectedTab: $selectedTab)
                    .padding(.horizontal)
                    .padding(.top, 4)
                
                // Content based on selected tab
                ScrollView {
                    VStack(spacing: 16) {
                        switch selectedTab {
                        case .handpicked:
                            HandpickedIndexesView()
                        case .maneki:
                            ManekiCuratedIndexesView(showQuizModal: $showManekiQuizModal)
                        case .community:
                            CommunityIndexesView(showCreateIndexSheet: $showCreateIndexSheet)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .background(Color.black)
                .scrollContentBackground(.hidden)
                .ignoresSafeArea(edges: .top)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showManekiQuizModal) {
            ManekiQuizModalView()
        }
        .sheet(isPresented: $showCreateIndexSheet) {
            CreateIndexView()
        }
    }
}

// MARK: - Index Source Tab Enum
enum IndexSourceTab: String, CaseIterable {
    case handpicked = "Team Picks"
    case maneki = "Maneki Quiz"
    case community = "Community"
}

// MARK: - Tab Selection View
struct IndexSourceTabView: View {
    @Binding var selectedTab: IndexSourceTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(IndexSourceTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(.subheadline)
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? Color.accentColor : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(1.5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Shared Components
struct IndexCard: View {
    var name: String
    var value: String
    var change: String
    var iconName: String = "chart.line.uptrend.xyaxis"
    var isPositive: Bool {
        return change.contains("+")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Text(change)
                            .font(.subheadline)
                            .foregroundColor(isPositive ? Color.green : Color.red)
                        
                        Text("Past 24h")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 18))
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            
            // Mini Graph Placeholder
            ZStack(alignment: .bottomLeading) {
                // Placeholder for actual chart
                Path { path in
                    let width: CGFloat = UIScreen.main.bounds.width - 64
                    let height: CGFloat = 60
                    
                    // Sample points for mini graph
                    let points = isPositive ?
                        [
                            CGPoint(x: 0, y: height * 0.5),
                            CGPoint(x: width * 0.2, y: height * 0.7),
                            CGPoint(x: width * 0.4, y: height * 0.3),
                            CGPoint(x: width * 0.6, y: height * 0.6),
                            CGPoint(x: width * 0.8, y: height * 0.2),
                            CGPoint(x: width, y: height * 0.1)
                        ] :
                        [
                            CGPoint(x: 0, y: height * 0.3),
                            CGPoint(x: width * 0.2, y: height * 0.2),
                            CGPoint(x: width * 0.4, y: height * 0.5),
                            CGPoint(x: width * 0.6, y: height * 0.4),
                            CGPoint(x: width * 0.8, y: height * 0.7),
                            CGPoint(x: width, y: height * 0.9)
                        ]
                    
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(isPositive ? Color.green : Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                
                // Gradient fill under the line
                LinearGradient(
                    gradient: Gradient(colors: [
                        isPositive ? Color.green.opacity(0.3) : Color.red.opacity(0.3),
                        isPositive ? Color.green.opacity(0.05) : Color.red.opacity(0.05)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 60)
            }
            .frame(height: 60)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Handpicked Indexes Tab
struct HandpickedIndexesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Team-curated AI Meme Indexes")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            IndexCard(name: "AI Memes Index", value: "1,428.67", change: "+5.2%", iconName: "brain")
            IndexCard(name: "Fortune AI Select", value: "785.32", change: "+2.8%", iconName: "sparkles")
            IndexCard(name: "AI Blue Chips", value: "2,432.89", change: "+3.7%", iconName: "crown")
            IndexCard(name: "AI Microcaps", value: "476.54", change: "-1.9%", iconName: "atom")
            
            Spacer(minLength: 50)
        }
    }
}

// MARK: - Maneki Quiz Tab
struct ManekiCuratedIndexesView: View {
    @Binding var showQuizModal: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                showQuizModal = true
            }) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title2)
                    
                    Text("Take Maneki's Investment Quiz")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentColor)
                )
                .foregroundColor(.white)
            }
            .padding(.vertical, 8)
            
            Text("Recommended for you")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            IndexCard(name: "Income Builder", value: "958.42", change: "+1.7%", iconName: "dollarsign.circle")
            IndexCard(name: "Growth Portfolio", value: "1,653.21", change: "+4.2%", iconName: "chart.bar.fill")
            IndexCard(name: "Balanced Strategy", value: "1,247.38", change: "+2.3%", iconName: "scale.3d")
            
            Spacer(minLength: 50)
        }
    }
}

// MARK: - Community Indexes Tab
struct CommunityIndexesView: View {
    @State private var selectedTimeFrame: TimeFrame = .month
    @Binding var showCreateIndexSheet: Bool
    
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
            
            // Leaderboard Items
            ForEach(1...5, id: \.self) { index in
                LeaderboardItem(
                    rank: index,
                    name: "Community Index \(index)",
                    roi: index % 2 == 0 ? "+\(20 + index).5%" : "+\(25 - index).8%",
                    creator: "user\(100 + index)"
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

// MARK: - Maneki Quiz Modal
struct ManekiQuizModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentQuestion = 0
    @State private var selectedAnswers: [Int] = []
    
    let questions = [
        "What is your investment time horizon?",
        "How would you react to a 20% market drop?",
        "What's your primary investment goal?"
    ]
    
    let answers = [
        ["Short term (< 1 year)", "Medium term (1-5 years)", "Long term (5+ years)"],
        ["Sell immediately", "Hold and wait", "Buy more"],
        ["Capital preservation", "Balanced growth", "Maximum returns"]
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                    .padding(.top, 32)
                
                Text("Maneki's Investment Quiz")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if currentQuestion < questions.count {
                    Text("Question \(currentQuestion + 1) of \(questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(questions[currentQuestion])
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(0..<answers[currentQuestion].count, id: \.self) { index in
                            Button(action: {
                                if selectedAnswers.count > currentQuestion {
                                    selectedAnswers[currentQuestion] = index
                                } else {
                                    selectedAnswers.append(index)
                                }
                                
                                // Move to next question or finish
                                if currentQuestion < questions.count - 1 {
                                    currentQuestion += 1
                                }
                            }) {
                                Text(answers[currentQuestion][index])
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor.secondarySystemBackground))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                                    )
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Results view
                    Text("Your Recommended Portfolio:")
                        .font(.headline)
                        .padding(.top)
                    
                    IndexCard(
                        name: "Balanced Growth Portfolio",
                        value: "1,247.38",
                        change: "+2.3%",
                        iconName: "star.fill"
                    )
                    .padding(.horizontal)
                    
                    Text("This portfolio matches your risk tolerance and time horizon.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Apply This Portfolio")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.accentColor)
                            )
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            .padding(.bottom, 32)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
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
