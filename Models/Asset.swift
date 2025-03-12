//
//  Asset.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

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
