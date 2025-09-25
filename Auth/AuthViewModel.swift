//
//  AuthViewModel.swift
//  Dojo
//
//  Created by Raymond Hou on 3/30/25.
//

import Foundation
import FirebaseAuth

enum AuthModelError : Error {
    case setLoggedInBeforeUserProfile
}

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    private var awaitingUserProfile: Bool = false

    init() {
        updateIsLoggedIn(user: Auth.auth().currentUser)
        
        // Listen to auth state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.updateIsLoggedIn(user: user)
        }
    }
    
    func updateIsLoggedIn(user: User?) {
        let previousLoggedInState = self.isLoggedIn
        
        self.isLoggedIn = user != nil
        
        if self.isLoggedIn && !previousLoggedInState && AuthManager.shared.userProfile == nil {
            ContentView.webSocketManager.getUserProfileIfConnectedAndLoggedIn(firebase_uid: user?.uid)
        }
    }

    func signOut() {
        AuthManager.shared.signOut()
    }
}
