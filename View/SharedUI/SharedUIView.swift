//
//  SharedUI.swift
//  Dojo
//
//  Created by Raymond Hou on 3/13/25.
//

import Foundation
import SwiftUI


// MARK: - News Card Component
struct NewsCard: View {
    var title: String
    var time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(time)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.1))
        .cornerRadius(10)
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

