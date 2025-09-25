//
//  News.swift
//  Dojo
//
//  Created by Raymond Hou on 4/9/25.
//

import Foundation
import SwiftUI

// MARK: - News Views

struct NewsItemView: View {
    let newsItem: NewsItem
    
    var body: some View {
        Button(action: {
            // Open news article in browser or dedicated view
            if let url = URL(string: newsItem.url) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(newsItem.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text(newsItem.source)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(formatDate(newsItem.publishedAt))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if let imageUrl = newsItem.imageUrl, !imageUrl.isEmpty {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color(UIColor.systemGray4))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    }
                }
                
                Text(newsItem.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        
        Divider()
            .background(Color.gray.opacity(0.3))
    }
    
    private func formatDate(_ dateString: String) -> String {
        // Simple date formatter - in a real app, this would parse the actual date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
        
        return dateString
    }
}

// MARK: - News Models

struct NewsItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let source: String
    let url: String
    let publishedAt: String
    let imageUrl: String?
    let relatedAssetId: String?
}

