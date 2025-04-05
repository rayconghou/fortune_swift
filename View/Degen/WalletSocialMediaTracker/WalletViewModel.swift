//
//  WalletViewModel.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import SwiftUI
import LocalAuthentication

class TradingWalletViewModel: ObservableObject {
    // MARK: Onboarding / Authentication
    @Published var pin: String = ""
    @Published var confirmPin: String = ""
    @Published var showPin: Bool = false
    @Published var biometricEnabled: Bool = false
    
    // If user is “fully done” setting up a wallet
    @Published var walletSetupComplete: Bool = false
    
    // If user wants to re-lock and re-ask for Face ID each time, you can use this:
    @Published var authenticated: Bool = false
    
    @Published var pinError: Bool = false
    @Published var isScanningFace: Bool = false
    
    // For demonstration, we show which step of the onboarding
    @Published var currentStep: OnboardingStep = .createPin
    
    // MARK: Wallet Data
    @Published var walletBalance: Double = 178532.65
    @Published var assets: [DegenAsset] = [
        DegenAsset(symbol: "BTC",   name: "Bitcoin",  price: 87432.51, change:  3.2, sentiment: 78, trend: .up),
        DegenAsset(symbol: "ETH",   name: "Ethereum", price: 4521.32,  change:  1.8, sentiment: 65, trend: .up),
        DegenAsset(symbol: "SOL",   name: "Solana",   price: 198.45,   change:  5.4, sentiment: 82, trend: .up),
        DegenAsset(symbol: "XRP",   name: "Ripple",   price: 0.58,     change: -2.1, sentiment: 42, trend: .down),
        DegenAsset(symbol: "DOGE",  name: "Dogecoin", price: 0.12,     change:  0.3, sentiment: 58, trend: .neutral),
        DegenAsset(symbol: "AVAX",  name: "Avalanche",price: 35.76,    change: -1.5, sentiment: 47, trend: .down),
        DegenAsset(symbol: "MATIC", name: "Polygon",  price: 0.87,     change:  2.3, sentiment: 71, trend: .up)
    ]
    
    var marketBullishPercentage: Int = 68
    var marketBearishPercentage: Int = 32
    
    enum OnboardingStep {
        case createPin
        case confirmPin
        case biometricSetup
        case setupComplete
    }
    
    // MARK: PIN Flow
    func appendPin(digit: String) {
        switch currentStep {
        case .createPin:
            if pin.count < 6 {
                pin += digit
                if pin.count == 6 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.3)) {
                            self.currentStep = .confirmPin
                        }
                    }
                }
            }
        case .confirmPin:
            if confirmPin.count < 6 {
                confirmPin += digit
                if confirmPin.count == 6 {
                    validatePins()
                }
            }
        default:
            break
        }
    }
    
    func deleteLastDigit() {
        switch currentStep {
        case .createPin:
            if !pin.isEmpty {
                pin.removeLast()
            }
        case .confirmPin:
            if !confirmPin.isEmpty {
                confirmPin.removeLast()
            }
        default:
            break
        }
    }
    
    private func validatePins() {
        if pin == confirmPin {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3)) {
                    self.currentStep = .biometricSetup
                }
            }
        } else {
            // mismatch => shake dots
            withAnimation(.spring(response: 0.3)) {
                pinError = true
            }
            confirmPin = ""
            
            // Reset error state after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    self.pinError = false
                }
            }
        }
    }
    
    // MARK: Biometric Flow
    func startBiometricSetup() {
        withAnimation {
            isScanningFace = true
        }
        
        // Simulate face scanning
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.biometricEnabled = true
            withAnimation {
                self.isScanningFace = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.3)) {
                    self.currentStep = .setupComplete
                }
            }
        }
    }
    
    func completeSetup() {
        // The user has completely set up their wallet
        withAnimation(.spring(response: 0.3)) {
            self.authenticated = true
            self.walletSetupComplete = true
        }
    }
}


// MARK: - Models

struct DegenAsset: Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let sentiment: Int
    let trend: TrendDirection
    
    enum TrendDirection: String {
        case up = "up"
        case down = "down"
        case neutral = "neutral"
    }
    
    var trendColor: Color {
        switch trend {
        case .up:      return Color.green
        case .down:    return Color.red
        case .neutral: return Color.gray
        }
    }
    
    var changeText: String {
        return change >= 0
            ? "+\(String(format: "%.1f", change))%"
            : "\(String(format: "%.1f", change))%"
    }
    
    var changeColor: Color {
        change >= 0 ? .green : .red
    }
    
    var sentimentColor: Color {
        if sentiment > 70 {
            return .green
        } else if sentiment > 50 {
            return .blue
        } else if sentiment > 30 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Reusable UI Components

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = sin(animatableData * .pi * 2) * 10
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

struct PinDot: View {
    var isFilled: Bool
    var error: Bool
    
    var body: some View {
        Circle()
            .fill(isFilled ? Color.blue : Color.gray.opacity(0.3))
            .frame(width: 16, height: 16)
            .scaleEffect(isFilled ? 1.1 : 1.0)
            .animation(.spring(response: 0.2), value: isFilled)
            .modifier(ShakeEffect(animatableData: error ? 1 : 0))
    }
}

struct SentimentProgressBar: View {
    var value: Double
    var color: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: geo.size.width, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: min(CGFloat(value) * geo.size.width, geo.size.width), height: 8)
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

struct NumberPadButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.1))
                    .overlay(
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                
                Text(number)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .frame(width: 70, height: 70)
        .buttonStyle(ScaleButtonStyle())
    }
}

struct FaceIDScanView: View {
    @Binding var isScanning: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 240, height: 240)
            
            Circle()
                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                .frame(width: 200, height: 200)
            
            if isScanning {
                // Scanning line
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 240, height: 4)
                    .offset(y: -120)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isScanning
                    )
                
                // Pulses
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        .frame(width: 200 + CGFloat(i * 20), height: 200 + CGFloat(i * 20))
                        .opacity(isScanning ? 0 : 1)
                        .animation(
                            Animation.easeOut(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.5),
                            value: isScanning
                        )
                }
            }
        }
    }
}
