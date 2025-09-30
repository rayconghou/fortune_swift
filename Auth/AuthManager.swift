import Foundation
import FirebaseAuth
// import AWSSQS // Temporarily disabled

enum AuthError: Error {
    case noCurrentUserAfterCreatingUser
    case userWithoutEmail
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    static let aws_region = "us-east-2"
    
    var userProfile: UserProfileViewModel?

    private init() {}

    func signUp(email: String, password: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("Auth signed in")
                if let user = Auth.auth().currentUser {
                    // COMMENTED OUT FOR FRONTEND DEVELOPMENT
                    // Task {
                    //     await self.addUserToDB(firebase_uid: user.uid, email: email, username: username)
                    // }
                    
                    completion(.success(()))
                } else {
                    completion(.failure(AuthError.noCurrentUserAfterCreatingUser))
                }
            }
        }
    }
    
    func addUserToDB(firebase_uid: String, email: String, username: String) async {
        // Temporarily disabled - AWS SDK removed for package resolution issues
        // TODO: Re-enable when AWS SDK is added back
        print("addUserToDB called but AWS SDK is temporarily disabled")
        /*
        do {
            let config = try await SQSClient.SQSClientConfiguration(region: AuthManager.aws_region)
            let sqsClient = SQSClient(config: config)
            _ = try await sqsClient.sendMessage(
                input: SendMessageInput(
                    messageBody: "{\"firebase_uid\":\"\(firebase_uid)\",\"username\":\"\(username)\",\"email\":\"\(email)\"}",
                    queueUrl: "https://sqs.\(AuthManager.aws_region).amazonaws.com/497197924608/LambdaRDSQueue"
                )
            )
        } catch _ as AWSSQS.QueueDoesNotExist {
            print("Error: The specified queue doesn't exist.")
            return
        } catch {
            print("Error: \(error)")
        }
        */
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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
