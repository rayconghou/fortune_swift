//
//  CreateIndexes.swift
//  Dojo
//
//  Created by Raymond Hou on 4/9/25.
//

import Foundation
import SwiftUI

// MARK: - Custom Index Creation Flow
struct CreateIndexView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: IndexSourceTab
    @ObservedObject var leaderboardVM: LeaderboardViewModel
    @Binding var isPresented: Bool
    @State private var indexName = ""
    @State private var indexDescription = ""
    @State private var selectedCategory: IndexCategory = .all
    @State private var selectedCoins: [CoinIndex] = []
    @State private var searchText = ""
    @State private var currentStep = 0
    @State private var showingPreview = false
    
    // Steps in the creation process
    let steps = ["Details", "Select Coins", "Allocation", "Review"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress indicator
                ProgressStepsView(steps: steps, currentStep: $currentStep)
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // Main content based on current step
                ScrollView {
                    VStack(spacing: 16) {
                        switch currentStep {
                        case 0:
                            indexDetailsView
                        case 1:
                            coinSelectionView
                        case 2:
                            allocationView
                        case 3:
                            reviewView
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Bottom navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            )
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    Button(action: {
                        if currentStep < steps.count - 1 {
                            withAnimation {
                                currentStep += 1
                            }
                        } else {
                            // Create and publish index
                            showingPreview = true
                        }
                    }) {
                        Text(currentStep < steps.count - 1 ? "Continue" : "Create Index")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                            .foregroundColor(.white)
                    }
                    .disabled(currentStep == 0 && indexName.isEmpty ||
                              currentStep == 1 && selectedCoins.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Create Custom Index")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if currentStep == 1 {
                        Button(action: {
                            // Show help about selection criteria
                        }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingPreview) {
                IndexCreatedView(
                    selectedTab: $selectedTab,
                    isPresented: $isPresented,
                    leaderboardVM: leaderboardVM,
                    indexName: indexName,
                    coins: selectedCoins
                )
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Step 1: Index Details
    private var indexDetailsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create Your Custom Index")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start by giving your index a name and description that helps others understand your investment thesis.")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Index Name")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("e.g., AI Disruptors 2025", text: $indexName)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Description (Optional)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $indexDescription)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Primary Category")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(IndexCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                action: { selectedCategory = category }
                            )
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Index Visibility")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Public indexes are visible to all users")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            
            Spacer()
        }
    }
    
    // MARK: - Step 2: Coin Selection
    private var coinSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Assets")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Choose up to 10 assets for your custom index.")
                .foregroundColor(.secondary)
            
            // Search and Category filter
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search coins", text: $searchText)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                Menu {
                    ForEach(IndexCategory.allCases, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            HStack {
                                Text(category.rawValue)
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
            }
            
            // Selected coins section
            if !selectedCoins.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected (\(selectedCoins.count)/10)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(selectedCoins) { coin in
                                SelectedCoinTag(coin: coin) {
                                    if let index = selectedCoins.firstIndex(where: { $0.id == coin.id }) {
                                        selectedCoins.remove(at: index)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Available coins
            Text(selectedCategory == .all ? "Popular Assets" : selectedCategory.rawValue)
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(filteredCoins) { coin in
                CoinSelectionRow(
                    coin: coin,
                    isSelected: selectedCoins.contains { $0.id == coin.id },
                    onSelect: {
                        toggleCoinSelection(coin)
                    }
                )
            }
        }
    }
    
    // MARK: - Step 3: Allocation View
    private var allocationView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Set Allocations")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Adjust the percentage allocation for each asset. Total must equal 100%.")
                .foregroundColor(.secondary)
            
            AllocationSummaryCard(
                allocatedPercentage: selectedCoins.map { $0.allocation }.reduce(0, +),
                averageAllocation: Double(selectedCoins.isEmpty ? 0 : 100 / selectedCoins.count)
            )
            
            // Equal weight button
            Button(action: {
                let equalWeight = 100 / selectedCoins.count
                for i in 0..<selectedCoins.count {
                    selectedCoins[i].allocation = Double(equalWeight)
                }
            }) {
                HStack {
                    Image(systemName: "equal.square.fill")
                    Text("Equal Weight")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(12)
            }
            .padding(.vertical, 8)
            
            Text("Asset Allocations")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ForEach(0..<selectedCoins.count, id: \.self) { index in
                AllocationRow(
                    coin: $selectedCoins[index],
                    onDelete: {
                        selectedCoins.remove(at: index)
                    }
                )
            }
        }
    }
    
    // MARK: - Step 4: Review View
    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review Your Index")
                .font(.title2)
                .fontWeight(.bold)
            
            IndexPreviewCard(name: indexName, description: indexDescription, category: selectedCategory)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Composition")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                CompositionPieChart(coins: selectedCoins)
                    .frame(height: 200)
                
                ForEach(selectedCoins.sorted { $0.allocation > $1.allocation }) { coin in
                    HStack {
                        Circle()
                            .fill(coin.color)
                            .frame(width: 10, height: 10)
                        
                        Text(coin.symbol)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(coin.allocation))%")
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            
            // Key metrics
            Text("Projected Performance")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 8)
            
            HStack(spacing: 12) {
                MetricCard(title: "Risk Rating", value: "Medium")
                MetricCard(title: "Est. Annual Return", value: "+12.4%")
            }
            
            HStack(spacing: 12) {
                MetricCard(title: "Volatility", value: "Medium")
                MetricCard(title: "Sharpe Ratio", value: "1.32")
            }
        }
    }
    
    // Helper function to toggle coin selection
    private func toggleCoinSelection(_ coin: CoinIndex) {
        if let index = selectedCoins.firstIndex(where: { $0.id == coin.id }) {
            selectedCoins.remove(at: index)
        } else {
            // Limit to 10 coins
            if selectedCoins.count < 10 {
                var newCoin = coin
                // Set initial allocation
                newCoin.allocation = Double(100 / (selectedCoins.count + 1))
                // Update existing coins to maintain 100% total
                let newAllocation = 100 / (selectedCoins.count + 1)
                for i in 0..<selectedCoins.count {
                    selectedCoins[i].allocation = Double(newAllocation)
                }
                selectedCoins.append(newCoin)
            }
        }
    }
    
    // Filtered coins based on search and category
    private var filteredCoins: [CoinIndex] {
        var filtered = allCoins
        
        if selectedCategory != .all {
            filtered = filtered.filter { $0.categories.contains(selectedCategory) }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.symbol.lowercased().contains(searchText.lowercased())
            }
        }
        
        return filtered
    }
    
    private func submitIndexToBackend() {
        guard let url = URL(string: "http://localhost:3001/api/indexes") else { return }

        let coinPayload = selectedCoins.map { ["symbol": $0.symbol, "allocation": $0.allocation] }

        let payload: [String: Any] = [
            "index_name": indexName,
            "description": indexDescription,
            "category": selectedCategory.rawValue,
            "coins": coinPayload,
            "creator": "demo_user" // Replace with actual user if needed
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("Encoding failed:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("POST failed:", error)
            } else {
                print("Index created and submitted to backend.")
            }
        }.resume()
    }
}

// MARK: - Progress Steps View
struct ProgressStepsView: View {
    let steps: [String]
    @Binding var currentStep: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                VStack(spacing: 8) {
                    // Step indicator
                    ZStack {
                        Circle()
                            .fill(currentStep >= index ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: 24, height: 24)
                        
                        if currentStep > index {
                            Image(systemName: "checkmark")
                                .font(.caption)
                                .foregroundColor(.white)
                        } else {
                            Text("\(index + 1)")
                                .font(.caption)
                                .foregroundColor(currentStep >= index ? .white : .gray)
                        }
                    }
                    
                    // Step name
                    Text(steps[index])
                        .font(.caption)
                        .foregroundColor(currentStep >= index ? .primary : .secondary)
                }
                
                // Connecting line
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(currentStep > index ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Color.accentColor : Color(UIColor.tertiarySystemBackground))
                )
                .foregroundColor(isSelected ? .white : .secondary)
        }
    }
}

// MARK: - Coin Selection Row
struct CoinSelectionRow: View {
    let coin: CoinIndex
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // Coin icon
                ZStack {
                    Circle()
                        .fill(Color(UIColor.tertiarySystemBackground))
                        .frame(width: 40, height: 40)
                    
                    Text(String(coin.symbol.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                
                // Coin details
                VStack(alignment: .leading, spacing: 2) {
                    Text(coin.symbol)
                        .font(.headline)
                    
                    Text(coin.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Price info
                VStack(alignment: .trailing, spacing: 2) {
                    Text("$\(coin.price, specifier: "%.2f")")
                        .font(.headline)
                    
                    Text(coin.priceChange > 0 ? "+\(coin.priceChange, specifier: "%.1f")%" : "\(coin.priceChange, specifier: "%.1f")%")
                        .font(.caption)
                        .foregroundColor(coin.priceChange > 0 ? .green : .red)
                }
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor.opacity(0.5) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Selected Coin Tag
struct SelectedCoinTag: View {
    let coin: CoinIndex
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(coin.symbol)
                .font(.subheadline)
                .padding(.leading, 8)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.trailing, 4)
        }
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
}

// MARK: - Allocation Row
struct AllocationRow: View {
    @Binding var coin: CoinIndex
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Coin icon
            ZStack {
                Circle()
                    .fill(coin.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(String(coin.symbol.prefix(1)))
                    .font(.headline)
                    .foregroundColor(coin.color)
            }
            
            // Coin details
            VStack(alignment: .leading, spacing: 2) {
                Text(coin.symbol)
                    .font(.headline)
                
                Text(coin.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Allocation percentage
            HStack {
                Button(action: {
                    if coin.allocation > 1 {
                        coin.allocation -= 1
                    }
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.gray)
                }
                
                Text("\(Int(coin.allocation))%")
                    .font(.headline)
                    .frame(minWidth: 40)
                
                Button(action: {
                    if coin.allocation < 100 {
                        coin.allocation += 1
                    }
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.gray)
                }
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// MARK: - Allocation Summary Card
struct AllocationSummaryCard: View {
    let allocatedPercentage: Double
    let averageAllocation: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Allocated")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(allocatedPercentage))%")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(allocatedPercentage == 100 ? .green : .primary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .opacity(0.3)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0.0, to: min(CGFloat(allocatedPercentage) / 100, 1.0))
                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .foregroundColor(allocatedPercentage == 100 ? .green : .accentColor)
                        .rotationEffect(Angle(degrees: 270.0))
                        .frame(width: 60, height: 60)
                    
                    Text("\(Int(allocatedPercentage))%")
                        .font(.footnote)
                        .bold()
                }
            }
            
            if allocatedPercentage != 100 {
                Text(allocatedPercentage > 100 ? "Please reduce allocations to equal 100%" : "Please increase allocations to reach 100%")
                    .font(.footnote)
                    .foregroundColor(allocatedPercentage > 100 ? .red : .yellow)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// MARK: - Index Preview Card
struct IndexPreviewCard: View {
    let name: String
    let description: String
    let category: IndexCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Creator badge
                HStack(spacing: 4) {
                    Image(systemName: "person.crop.circle.fill")
                    Text("You")
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            if !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// MARK: - Composition Pie Chart
struct CompositionPieChart: View {
    let coins: [CoinIndex]
    
    var body: some View {
        ZStack {
            // This is a placeholder for an actual pie chart implementation
            // In a real implementation, you'd use SwiftUI's Path or a charting library
            ForEach(0..<coins.count, id: \.self) { index in
                let startAngle = self.startAngle(for: index)
                let endAngle = self.endAngle(for: index)
                
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 100))
                    path.addArc(
                        center: CGPoint(x: 100, y: 100),
                        radius: 80,
                        startAngle: Angle(degrees: startAngle),
                        endAngle: Angle(degrees: endAngle),
                        clockwise: false
                    )
                }
                .fill(coins[index].color)
            }
            
            Circle()
                .fill(Color.black)
                .frame(width: 50, height: 50)
            
            Text("\(coins.count)")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
        .frame(maxWidth: .infinity)
    }
    
    // Helper functions to calculate pie chart angles
    private func startAngle(for index: Int) -> Double {
        let priorSegments = coins[0..<index].map { $0.allocation }.reduce(0, +)
        return priorSegments / 100 * 360
    }
    
    private func endAngle(for index: Int) -> Double {
        let priorSegments = coins[0...index].map { $0.allocation }.reduce(0, +)
        return priorSegments / 100 * 360
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

// MARK: - Success View
struct IndexCreatedView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: IndexSourceTab
    @Binding var isPresented: Bool
    @ObservedObject var leaderboardVM: LeaderboardViewModel
    let indexName: String
    let coins: [CoinIndex]
    
    var body: some View {
        VStack(spacing: 24) {
            // Success animation placeholder
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.green)
            }
            .padding(.top, 60)
            
            Text("Index Created Successfully!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your custom index \"\(indexName)\" is now live and visible to the community.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Index Composition")
                    .font(.headline)
                
                ForEach(coins.prefix(3)) { coin in
                    HStack {
                        Text(coin.symbol)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(Int(coin.allocation))%")
                    }
                }
                
                if coins.count > 3 {
                    Text("+ \(coins.count - 3) more assets")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .padding(.horizontal, 32)
            
            Text("Earn MANEKI tokens when others invest in your index!")
                .font(.caption)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                )
            
            Button(action: {
                dismiss()
            }) {
                Text("View My Index")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentColor)
                    )
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 32)
            .padding(.top, 16)
            
            Button(action: {
                leaderboardVM.fetchLeaderboard()
                selectedTab = .community
                isPresented = false
            }) {
                Text("Back to Indexes")
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.bottom, 32)
        .onAppear {
            submitIndexToBackend()
        }
    }
    
    private func submitIndexToBackend() {
        print("🟡 Submitting index to backend...")

        guard let url = URL(string: "http://localhost:3001/api/indexes") else { return }

        let coinPayload = coins.map { ["symbol": $0.symbol, "allocation": $0.allocation] }

        let payload: [String: Any] = [
            "index_name": indexName,
            "description": "",
            "category": "AI",
            "coins": coinPayload,
            "creator": "demo_user"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            print("Encoding failed:", error)
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            print("✅ Submission complete")
            if let data = data {
                print("📄 Response: \(String(decoding: data, as: UTF8.self))")
            }
            if let error = error {
                print("❌ Submission error: \(error)")
            }
        }.resume()
    }

}

// MARK: - Model Types
enum IndexCategory: String, CaseIterable {
    case all = "All"
    case defi = "DeFi"
    case meme = "Meme Coins"
    case gaming = "Gaming"
    case ai = "AI"
    case infrastructure = "Infrastructure"
    case layer2 = "Layer 2"
    case metaverse = "Metaverse"
    case web3 = "Web3"
    case fintech = "FinTech"
}

struct CoinIndex: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: Double
    let priceChange: Double
    let categories: [IndexCategory]
    var allocation: Double = 0
    var color: Color {
        // Generate predictable colors based on symbol
        let colors: [Color] = [.blue, .purple, .green, .orange, .red, .pink, .teal, .yellow, .indigo]
        let index = abs(symbol.hashValue) % colors.count
        return colors[index]
    }
}

let allCoins: [CoinIndex] = [
    CoinIndex(name: "Bitcoin", symbol: "BTC", price: 57824.58, priceChange: 2.3, categories: [.infrastructure]),
    CoinIndex(name: "Ethereum", symbol: "ETH", price: 3142.87, priceChange: 1.5, categories: [.infrastructure, .defi]),
    CoinIndex(name: "Solana", symbol: "SOL", price: 142.73, priceChange: 3.8, categories: [.infrastructure, .gaming]),
    CoinIndex(name: "Cardano", symbol: "ADA", price: 0.62, priceChange: -0.4, categories: [.infrastructure]),
    CoinIndex(name: "Dogecoin", symbol: "DOGE", price: 0.21, priceChange: 6.2, categories: [.meme]),
    CoinIndex(name: "Shiba Inu", symbol: "SHIB", price: 0.000027, priceChange: 5.7, categories: [.meme]),
    CoinIndex(name: "Chainlink", symbol: "LINK", price: 19.45, priceChange: 4.2, categories: [.defi, .infrastructure]),
    CoinIndex(name: "Aave", symbol: "AAVE", price: 128.17, priceChange: -1.2, categories: [.defi]),
    CoinIndex(name: "Uniswap", symbol: "UNI", price: 11.38, priceChange: 2.0, categories: [.defi]),
    CoinIndex(name: "Render", symbol: "RNDR", price: 9.52, priceChange: 7.9, categories: [.ai]),
    CoinIndex(name: "Fetch.ai", symbol: "FET", price: 2.12, priceChange: 6.3, categories: [.ai]),
    CoinIndex(name: "The Graph", symbol: "GRT", price: 0.31, priceChange: 3.2, categories: [.web3]),
    CoinIndex(name: "Sandbox", symbol: "SAND", price: 0.72, priceChange: -0.9, categories: [.metaverse]),
    CoinIndex(name: "Decentraland", symbol: "MANA", price: 0.61, priceChange: -1.5, categories: [.metaverse]),
    CoinIndex(name: "Polygon", symbol: "MATIC", price: 1.12, priceChange: 1.8, categories: [.layer2, .defi]),
    CoinIndex(name: "Optimism", symbol: "OP", price: 3.46, priceChange: 4.1, categories: [.layer2]),
    CoinIndex(name: "Arbitrum", symbol: "ARB", price: 2.17, priceChange: 2.5, categories: [.layer2]),
    CoinIndex(name: "Worldcoin", symbol: "WLD", price: 5.92, priceChange: -3.4, categories: [.web3]),
    CoinIndex(name: "SUI", symbol: "SUI", price: 1.48, priceChange: 2.6, categories: [.infrastructure]),
    CoinIndex(name: "Ripple", symbol: "XRP", price: 0.73, priceChange: -0.2, categories: [.fintech])
]
