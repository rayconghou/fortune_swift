//
//  KeychainHelper.swift
//  FortuneCollective
//
//  Created by Raymond Hou on 4/4/25.
//

import Foundation
import Security

class KeychainHelper {
    static func save(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            SecItemDelete(query as CFDictionary) // Remove old value
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    static func read(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == noErr,
           let data = result as? Data,
           let string = String(data: data, encoding: .utf8) {
            return string
        }
        return nil
    }
}
