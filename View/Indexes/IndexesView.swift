//
//  IndexesView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

// MARK: - Other Tab Views

struct IndexesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Indexes")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 35)
                
                IndexCard(name: "DeFi Index", value: "2,345.67", change: "+1.2%")
                IndexCard(name: "NFT Market Index", value: "785.32", change: "-0.5%")
                IndexCard(name: "Metaverse Index", value: "432.89", change: "+3.7%")
                IndexCard(name: "Layer 1 Index", value: "1,876.54", change: "+2.1%")
                
                Text("Historical Performance")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 350, height: 250)
                    .overlay(Text("Index Performance Chart").foregroundColor(.white))
//                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
        }
        .background(Color.black)
    }
}
