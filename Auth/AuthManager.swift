import Foundation
import FirebaseAuth
import AWSSQS

enum AuthError: Error {
    case noCurrentUserAfterCreatingUser
    case userWithoutEmail
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()

    private init() {}

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("Auth signed in")
                if let user = Auth.auth().currentUser {
                    if let email = user.email {
                        //              Add menus to prompt user to set up profile
                                        
//                        Task {
//                            await self.addUserToDB(firebase_uid: user.uid, email: email)
//                        }
                        
                        completion(.success(()))
                    } else {
                        completion(.failure(AuthError.userWithoutEmail))
                    }
                } else {
                    completion(.failure(AuthError.noCurrentUserAfterCreatingUser))
                }
            }
        }
    }
    
    func addUserToDB(firebase_uid: String, email: String) async {
        do {
            let config = try await SQSClient.SQSClientConfiguration(region: "us-east-2")
            let sqsClient = SQSClient(config: config)
            _ = try await sqsClient.sendMessage(
                input: SendMessageInput(
                    messageBody: "{\"firebase_uid\":\"\(firebase_uid)\",\"email\":\"\(email)\"}",
                    queueUrl: "https://sqs.us-east-2.amazonaws.com/497197924608/LambdaRDSQueue"
                )
            )
        } catch _ as AWSSQS.QueueDoesNotExist {
            print("Error: The specified queue doesn't exist.")
            return
        } catch {
            print("Error: \(error)")
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
//                if let user = Auth.auth().currentUser {
//                    print("uid: \(user.uid)")
//                }
//                isSignedIn = true
                // Add more onboarding stuff
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            AuthView()
        } catch {
            print("Sign-out failed:", error)
        }
    }

    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
