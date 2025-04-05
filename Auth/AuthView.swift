import Foundation
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var loading = false
    @State private var isNewUser = false

    var body: some View {
        VStack(spacing: 24) {
            Text(isNewUser ? "Create Account" : "Sign In to Fortune")
                .font(.title)
                .bold()

            TextField("Enter your email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .padding(.horizontal)

            SecureField("Enter your password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                loading = true
                let authAction = isNewUser
                    ? AuthManager.shared.signUp
                    : AuthManager.shared.signIn

                authAction(email, password) { result in
                    loading = false
                    switch result {
                    case .success:
                        authViewModel.isLoggedIn = true
                    case .failure(let error):
                        message = "Error: \(error.localizedDescription)"
                    }
                }
            }) {
                Text(isNewUser ? "Create Account" : "Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(email.isEmpty || password.isEmpty || loading)

            Button(action: {
                isNewUser.toggle()
            }) {
                Text(isNewUser ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .padding(.top, 100)
    }

    private func handleResult(_ result: Result<Void, Error>) {
        switch result {
        case .success:
            message = isNewUser ? "Account created!" : "Signed in!"
        case .failure(let error):
            message = "Error: \(error.localizedDescription)"
        }
    }
}
