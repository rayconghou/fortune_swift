//
//  BIometricSetup.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import SwiftUI

struct BiometricSetupView: View {
    @ObservedObject var viewModel: TradingWalletViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "faceid")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .symbolEffect(.pulse, options: .repeating)
                
                Text("Set Up Biometric Authentication")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Enable Face ID for instant, secure access to your wallet.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer().frame(height: 60)
            
            FaceIDScanView(isScanning: $viewModel.isScanningFace)
                .frame(width: 240, height: 240)
            
            Spacer().frame(height: 60)
            
            Button(action: {
                viewModel.startBiometricSetup()
            }) {
                Text("Scan Face ID")
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
            .disabled(viewModel.isScanningFace)
            .buttonStyle(ScaleButtonStyle())
            
            Spacer()
            
            Text("Your biometric data never leaves your device.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
        .padding()
        .navigationTitle("SentimentTrader")
        .transition(.opacity.combined(with: .move(edge: .leading)))
    }
}

