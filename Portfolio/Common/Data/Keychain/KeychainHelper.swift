//
//  KeychainHelper.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 22/11/24.
//

import Foundation

enum KeychainError: Error {
    case unableToSave
    case unableToLoad
    case unableToDelete
}

final class KeychainHelper {

    private static var service: String {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            fatalError("Error: Bundle Identifier not found")
        }
        return bundleID
    }

    private init() {}

    static func save(_ data: Data, service: String = KeychainHelper.service, account: String) throws {

        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        // Add data in query to keychain
        var status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary

            // Update existing item
            status = SecItemUpdate(query, attributesToUpdate)
        }

        if status != errSecSuccess {
            throw KeychainError.unableToSave
        }
    }

    static func read(service: String = KeychainHelper.service, account: String) throws -> Data {

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var item: AnyObject?
        let status = SecItemCopyMatching(query, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            throw KeychainError.unableToLoad
        }

        return data
    }

    static func delete(service: String = KeychainHelper.service, account: String) throws {

        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        // Delete item from keychain
        let status = SecItemDelete(query)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unableToDelete
        }
    }
}

extension KeychainHelper {

    static func save<T: Codable>(_ item: T, service: String = KeychainHelper.service, account: String) throws {
        // Encode as JSON data and save in keychain
        let data = try JSONEncoder().encode(item)
        return try save(data, service: service, account: account)
    }

    static func read<T: Codable>(service: String = KeychainHelper.service, account: String) throws -> T {
        // Read item data from keychain
        let data = try read(service: service, account: account)

        // Decode JSON data to object
        return try JSONDecoder().decode(T.self, from: data)
    }

    static func reset() {
        let secItemClasses =  [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
            kSecAttrService,
            kSecValueData,
            kSecAttrAccount
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}
