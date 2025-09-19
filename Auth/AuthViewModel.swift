//
//  AuthViewModel.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/30/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
        
        // Listen to auth state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }

    func signOut() {
        AuthManager.shared.signOut()
    }
}
