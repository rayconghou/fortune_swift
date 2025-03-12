//
//  DegenView.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/11/25.
//

import Foundation
import SwiftUI

struct DegenView: View {
    @Binding var isEnabled: Bool
    
    var body: some View {
        VStack {
            if isEnabled {
                Text("DEGEN MODE ACTIVE")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding(.top, 20)
                
                Text("High-risk trading enabled")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack(spacing: 20) {
                    DegenTradingCard(title: "Leverage Trading", description: "Trade with up to 100x leverage")
                    DegenTradingCard(title: "Options Trading", description: "Advanced derivatives market")
                    DegenTradingCard(title: "Futures", description: "Perpetual contracts with high liquidity")
                    DegenTradingCard(title: "Flash Loans", description: "DeFi protocol flash loans")
                }
//                .padding()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 60, height: 80)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                    
                    Text("Degen Mode Disabled")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Enable Degen Mode from the sidebar to access advanced high-risk trading features.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                    
                    Button(action: { isEnabled = true }) {
                        Text("Enable Degen Mode")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
