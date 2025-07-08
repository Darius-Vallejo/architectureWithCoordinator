//
//  DateExtension.swift
//  Portfolio
//
//  Created by Dario Fernando Vallejo Posada on 21/12/24.
//

import Foundation

extension Date {

    typealias MonthRange = (minDate: Date, maxDate: Date)

    struct Format {
        static let defaultWithoutTime = "yyyy-MM-dd"
        static let monthAndYear = "MMMM yyyy"
    }

    func fromString(_ dateString: String, format: String = Format.defaultWithoutTime) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }

    func formatDateToCustomString(dateFormatString: String = "E d, MMMM yyyy" ) -> String {
        let formatter = DateFormatter()
        // Format: Mon 6, January 2024
        formatter.dateFormat = dateFormatString
        return formatter.string(from: self)
    }

    static func monthName(from monthNumber: Int) -> String {
        // Ensure the month number is valid
        guard (1...12).contains(monthNumber) else { return "Invalid Month" }

        // Create a DateComponents object with the given month
        var components = DateComponents()
        components.month = monthNumber

        // Use the current calendar to create a date
        let calendar = Calendar.current
        let date = calendar.date(from: components) ?? Date()

        // Configure a DateFormatter
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL" // Full month name
        formatter.locale = Locale.current // Use the user's locale

        // Get the localized month name
        return formatter.string(from: date)
    }

    /// Returns the start-of-month and end-of-month for a given date.
    /// The end-of-month is actually the last second of that month (1 second before the start of the next month).
    func monthBounds(using calendar: Calendar = .current) -> MonthRange? {
        // 1) Find the DateInterval representing the entire month
        guard let monthInterval = calendar.dateInterval(of: .month, for: self) else {
            return nil
        }

        // 2) The start is easy: e.g., 2025-03-01 at 00:00
        let startOfMonth = monthInterval.start

        // 3) The end is the very last second of that month (one second before the next month's start).
        // monthInterval.end is the start of the *next* month, so subtract 1 second.
        guard let endOfMonth = calendar.date(byAdding: .second, value: -1, to: monthInterval.end) else {
            return nil
        }

        return (startOfMonth, endOfMonth)
    }
}
