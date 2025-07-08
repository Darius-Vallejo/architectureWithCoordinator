//
//  StringsHelpers.swift
//  portfolio
//
//  Created by Dario Fernando Vallejo Posada on 17/11/24.
//
import Foundation

extension String {
    static var empty: String {
        return ""
    }

    /// Trimming long string to the specified character count limit.
    /// - Parameters:
    ///   - maxLength: character limit
    /// - Returns: return truncated string with appending ellipsis if applied.
    func truncateStringIfNeeded(maxLength: Int) -> String {
        if self.count > maxLength {
            let endIndex = self.index(self.startIndex, offsetBy: maxLength)
            return String(self[..<endIndex]) + "..."
        } else {
            return self
        }
    }

    static func formatToCurrency(_ value: Double, currencyCode: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode // Set the desired currency code
        formatter.maximumFractionDigits = 2   // Adjust fraction digits as needed
        formatter.minimumFractionDigits = 2

        return formatter.string(from: NSNumber(value: value))
    }

}
