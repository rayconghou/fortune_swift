//
//  ApplePay.swift
//  Dojo
//
//  Created by Raymond Hou on 3/13/25.
//

import Foundation
import SwiftUI
import PassKit

// MARK: - Apple Pay Integration (mockup as of 3/11)

struct MockApplePayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.mockPaymentFlow), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func mockPaymentFlow() {
            print("User tapped the mock Apple Pay button.")
            
            let alert = UIAlertController(
                title: "Mock Apple Pay",
                message: "This is a prototype flow.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            // Find the top-most view controller to present the alert
            if let topVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?
                .rootViewController {
                
                DispatchQueue.main.async {
                    topVC.present(alert, animated: true)
                }
            }
        }
    }
}
