//
//  DateFormatter+Iso8601Full.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-16.
//

import Foundation

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
}
