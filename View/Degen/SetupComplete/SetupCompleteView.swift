//
//  SetupCompleteView.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import SwiftUI

struct SetupCompleteView: View {
    @ObservedObject var viewModel: SecureSignInFlowViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Subtle success gradient behind
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.3),
                                Color.blue.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            .symbolEffect(.pulse, options: .repeating)
            
            Spacer().frame(height: 40)
            
            Text("Wallet Setup Complete!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your PIN and Face ID are now set up. Welcome to SentimentTrader.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 4)
            
            Spacer().frame(height: 60)
            
            Button(action: {
                viewModel.completeSetup()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 32)
            .buttonStyle(ScaleButtonStyle())
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}
