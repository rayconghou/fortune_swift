//
//  BiometricAuthManager.swift
//  Dojo
//
//  Created by Raymond Hou on 4/14/25.
//

import Foundation
import LocalAuthentication
import UIKit

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    
    private init() {}
    
    func canUseBiometricAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func getBiometricType() -> LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Authenticate using Face ID or Touch ID")
        { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func showBiometricsSettingsAlert(_ controller: UIViewController) {
        let alertController = UIAlertController(
            title: "Enable Face ID/Touch ID",
            message: "To use biometric authentication, please enable it for this app in your Settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true)
    }
}
