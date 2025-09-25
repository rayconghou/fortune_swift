//
//  WebSocketManager.swift
//  FortuneCollective
//
//  Created by Hugh on 9/20/25.
//


import Foundation

enum WebSocketError: Error {
    case badResponse
}

class WebSocketManager: NSObject, URLSessionWebSocketDelegate {
    var webSocketTask: URLSessionWebSocketTask?
    var urlSession: URLSession?

    var isConnected: Bool = false
    
    private var firebase_uid: String? = nil
    
    func connect(url: URL) {
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        var request = URLRequest(url: url)
//        request.setValue("x-api-key", forHTTPHeaderField: "FoqLmICk99wIrFxV0wB13sWzoKMe4ot2dSTWMhp6")
        webSocketTask = urlSession?.webSocketTask(with: request)
        webSocketTask?.resume()
        print("Attempting to connect to WebSocket...")
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text: \(text)")
                    
                    // Process the received message
                    Task {
                        let decoder = JSONDecoder()
                        guard let jsonData = text.data(using: .utf8) else {
                            throw WebSocketError.badResponse
                        }
                        
                        struct userProperties: Decodable {
                            let email: String
                            let username: String
                        }
                        
                        do {
                            let userProfileProperties = try decoder.decode(userProperties.self, from: jsonData)
                            AuthManager.shared.userProfile = UserProfileViewModel(email: userProfileProperties.email, username: userProfileProperties.username)
                        } catch {
                            print("Error decoding JSON: \(error.localizedDescription)")
                        }
                    }
                    
                case .data(let data):
                    print("Received data: \(data)")
                    // Process the received data
                @unknown default:
                    break
                }
                self?.receiveMessage() // Continue receiving
            }
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket connection opened.")
        receiveMessage() // Start receiving messages once connected
        
        isConnected = true
        
        getUserProfileIfConnectedAndLoggedIn(firebase_uid: nil)
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket connection closed with code: \(closeCode)")
        // Handle disconnection, potentially attempt to reconnect
        
        isConnected = false
    }
    
    func getUserProfileIfConnectedAndLoggedIn(firebase_uid: String?) {
        var uid: String? = nil
        if firebase_uid != nil {
            uid = firebase_uid
            
            self.firebase_uid = firebase_uid
        } else if self.firebase_uid != nil {
            uid = self.firebase_uid
        }
        
        if let unwrapped_uid = uid {
            if isConnected && unwrapped_uid != nil {                
                send(message: "{\"action\": \"getUserProfile\", \"firebase_uid\": \"" + unwrapped_uid + "\"}")
            }
        }
    }
}
