//
//  Encodable+Extensions.swift
//  instaflix
//
//  Created by Dario Fernando Vallejo Posada on 7/09/24.
//

import Foundation

extension Encodable {
    func dictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) -> [String: Any]? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
        do {
            let jsonData = try jsonEncoder.encode(self)
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return jsonObject
            }
        } catch let myJSONError {
            print("dictionaryFromEncodable Error: \(myJSONError.localizedDescription)")
        }
        return nil
    }
}
