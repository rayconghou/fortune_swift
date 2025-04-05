//
//  WalletService.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 3/31/25.
//

import Foundation
import Combine

// MARK: - Wallet Connection Models

enum WalletType {
    case metamask
    case phantom
    case walletConnect
    case trustWallet
}

struct WalletAccount {
    let address: String
    let chain: Chain
    let type: WalletType
    var balance: String
}

enum WalletError: Error {
    case connectionFailed
    case userRejected
    case invalidChain
    case notConnected
    case transactionFailed
}

// MARK: - Wallet Service

class WalletService {
    // Published properties
    @Published var currentAccount: WalletAccount?
    @Published var isConnecting = false
    @Published var error: WalletError?
    @Published var isConnected: Bool = false
    
    // Private properties
    private var cancellables = Set<AnyCancellable>()
    
    // Connection methods
    func connect(type: WalletType, chain: Chain) async throws -> WalletAccount {
        isConnecting = true
        error = nil
        
        do {
            // Simulate wallet connection
            try await Task.sleep(nanoseconds: 1_500_000_000)
            
            // In a real app, this would use web3 libraries to connect to wallets
            let mockAccount = createMockAccount(for: type, on: chain)
            
            await MainActor.run {
                self.currentAccount = mockAccount
                self.isConnected = true
                self.isConnecting = false
            }
            
            return mockAccount
        } catch {
            await MainActor.run {
                self.error = error as? WalletError ?? .connectionFailed
                self.isConnecting = false
            }
            
            throw error
        }
    }
    
    func disconnect() {
        currentAccount = nil
        isConnected = false
    }
    
//    func switchChain(to chain: Chain) async throws {
//        guard var account = currentAccount else {
//            throw WalletError.notConnected
//        }
//        
//        // Simulate chain switching
//        try await Task.sleep(nanoseconds: 1_000_000_000)
//        
//        // Update the account with the new chain
//        account.chain = chain
//        account.balance = generateRandomBalance(for: chain)
//        
//        await MainActor.run {
//            self.currentAccount = account
//        }
//    }
//    
    // Helper methods
    private func createMockAccount(for type: WalletType, on chain: Chain) -> WalletAccount {
        let address: String
        
        switch type {
        case .metamask, .walletConnect, .trustWallet:
            // Ethereum-style address
            address = "0x" + String((0..<40).map { _ in "0123456789abcdef".randomElement()! })
        case .phantom:
            // Solana-style address
            address = String((0..<44).map { _ in "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".randomElement()! })
        }
        
        return WalletAccount(
            address: address,
            chain: chain,
            type: type,
            balance: generateRandomBalance(for: chain)
        )
    }
    
    private func generateRandomBalance(for chain: Chain) -> String {
        let value = Double.random(in: 0.01...5.0)
        return String(format: "%.4f", value)
    }
    
    // Transaction methods
    func sendTransaction(to address: String, amount: String, data: Data? = nil) async throws -> String {
        guard let account = currentAccount else {
            throw WalletError.notConnected
        }
        
        // Simulate transaction
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Generate a random transaction hash
        let txHash: String
        if account.chain == .sol {
            txHash = String((0..<64).map { _ in "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".randomElement()! })
        } else {
            txHash = "0x" + String((0..<64).map { _ in "0123456789abcdef".randomElement()! })
        }
        
        return txHash
    }
    
    func getTokenBalance(tokenAddress: String) async throws -> String {
        guard let account = currentAccount else {
            throw WalletError.notConnected
        }
        
        // Simulate fetching token balance
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Return a random balance
        let value = Double.random(in: 10.0...100000.0)
        return String(format: "%.2f", value)
    }
}
