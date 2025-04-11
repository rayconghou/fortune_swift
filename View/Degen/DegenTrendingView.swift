//
//  DegenTrendingView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI

struct DegenTrendingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    /// The DexScreener-based ViewModel
    @StateObject var degenVM = DegenTrendingViewModel()

    @State private var searchText = ""

    // Filter the fetched tokens by chainId, token address, or description (whatever you like)
    var filteredTokens: [DexScreenerTokenProfile] {
        if searchText.isEmpty {
            return degenVM.latestTokens
        } else {
            return degenVM.latestTokens.filter {
                $0.tokenAddress.localizedCaseInsensitiveContains(searchText) ||
                $0.chainId.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search new tokens...", text: $searchText)
                        .foregroundColor(.white)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(white: 0.15))
                .cornerRadius(8)
                .padding([.leading, .trailing, .top], 16)

                // Token List
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredTokens) { token in
                            DegenTokenRow(token: token)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .padding(16)
                }
                .background(Color.black)

                // If we want an error message label:
                if let errorMsg = degenVM.errorMessage {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Trending")
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                    }
                }
            }
        }
    }
}

struct DegenTokenRow: View {
    let token: DexScreenerTokenProfile
    
    var body: some View {
        HStack(spacing: 12) {
            // Token Icon
            AsyncImage(url: URL(string: token.icon ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 24, height: 24)
            .clipShape(Circle())

            // Info: chain, address, or description
            VStack(alignment: .leading, spacing: 2) {
                Text(token.tokenAddress.prefix(8) + "...")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(token.chainId.uppercased())
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Possibly show a short snippet of the description (for “degen hype”)
            if let desc = token.description, !desc.isEmpty {
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color(white: 0.1))
        .cornerRadius(8)
    }
}


struct DegenTrendingView_Previews: PreviewProvider {
    static var previews: some View {
        DegenTrendingView()
            .preferredColorScheme(.dark)
    }
}
