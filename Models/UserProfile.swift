//
//  UserProfile.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/13/25.
//

import Foundation
import SwiftUI

// MARK: - Profile Modal

class UserProfileViewModel: ObservableObject {
    @Published var name: String
    @Published var email: String
    
    init(name: String = "James Wang", email: String = "james@example.com") {
        self.name = name
        self.email = email
    }
}

struct ProfileSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userProfile: UserProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Profile Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Name & Email
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name").foregroundColor(.gray)
                    TextField("Name", text: $userProfile.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Email").foregroundColor(.gray)
                    TextField("Email", text: $userProfile.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 20)
                
                // The mock Apple Pay button:
                MockApplePayButton()
                    .frame(width: 200, height: 44) // approximate size
                
                Spacer()
                
                // Dismiss button
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                .padding(.bottom, 50)
                
            }
            .padding()
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}
