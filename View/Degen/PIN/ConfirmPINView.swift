//
//  ConfirmPINView.swift
//  Dojo
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import SwiftUI
import LocalAuthentication

struct ConfirmPINView: View {
    @ObservedObject var viewModel: SecureSignInFlowViewModel
    @State private var biometricAttempted = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .symbolEffect(.pulse, options: .repeating)
                    
                    Text("Confirm Your PIN")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Enter your 6-digit PIN again to confirm.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                Spacer().frame(height: 40)
                
                // PIN Dots
                HStack(spacing: 16) {
                    ForEach(0..<6, id: \.self) { index in
                        PinDot(
                            isFilled: index < viewModel.confirmPin.count,
                            error: viewModel.pinError
                        )
                    }
                }
                
                if viewModel.showPin && !viewModel.confirmPin.isEmpty {
                    Text(viewModel.confirmPin)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.top, 8)
                        .transition(.opacity)
                }
                
                Spacer()
                
                numberPad
                    .padding(.bottom)
            }
            .padding()
            .onAppear {
                if !biometricAttempted {
                    biometricAttempted = true
                    runBiometricAuthentication()
                }
            }
        }
    }
    
    /// Automatically trigger biometric authentication
        private func runBiometricAuthentication() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication() {
            BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
                if success {
                    DispatchQueue.main.async {
                        // You may want to mark biometric as verified in your view model.
                        viewModel.biometricVerified = true
                        // Since biometric confirms the identity, you could automatically
                        // move to the next step in your onboarding flow.
                        viewModel.authenticated = true
                    }
                } else {
                    // Optionally you can alert the user or simply log the error.
                    print("Biometric authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            print("Biometric authentication not available.")
        }
    }
    
    var numberPad: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                NumberPadButton(number: "1") { viewModel.appendPin(digit: "1") }
                NumberPadButton(number: "2") { viewModel.appendPin(digit: "2") }
                NumberPadButton(number: "3") { viewModel.appendPin(digit: "3") }
            }
            
            HStack(spacing: 24) {
                NumberPadButton(number: "4") { viewModel.appendPin(digit: "4") }
                NumberPadButton(number: "5") { viewModel.appendPin(digit: "5") }
                NumberPadButton(number: "6") { viewModel.appendPin(digit: "6") }
            }
            
            HStack(spacing: 24) {
                NumberPadButton(number: "7") { viewModel.appendPin(digit: "7") }
                NumberPadButton(number: "8") { viewModel.appendPin(digit: "8") }
                NumberPadButton(number: "9") { viewModel.appendPin(digit: "9") }
            }
            
            HStack(spacing: 24) {
                Button(action: { viewModel.showPin.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: viewModel.showPin ? "eye.fill" : "eye.slash.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .frame(width: 70, height: 70)
                .buttonStyle(ScaleButtonStyle())
                
                NumberPadButton(number: "0") { viewModel.appendPin(digit: "0") }
                
                Button(action: { viewModel.deleteLastDigit() }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .frame(width: 70, height: 70)
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}
