//
//  KeychainHelper.swift
//  Dojo
//
//  Created by Raymond Hou on 4/4/25.
//

import Foundation
import Security
import SwiftUI

//class KeychainHelper {
//    static func save(_ value: String, forKey key: String) {
//        if let data = value.data(using: .utf8) {
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrAccount as String: key,
//                kSecValueData as String: data
//            ]
//            SecItemDelete(query as CFDictionary) // Remove old value
//            SecItemAdd(query as CFDictionary, nil)
//        }
//    }
//    
//    static func read(forKey key: String) -> String? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrAccount as String: key,
//            kSecReturnData as String: true,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//        var result: AnyObject?
//        if SecItemCopyMatching(query as CFDictionary, &result) == noErr,
//           let data = result as? Data,
//           let string = String(data: data, encoding: .utf8) {
//            return string
//        }
//        return nil
//    }
//}

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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
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
