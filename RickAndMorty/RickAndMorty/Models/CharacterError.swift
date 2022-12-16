/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An enumeration of Quake fetch and consumption errors.
*/

import Foundation

enum CharacterError: Error {
    case missingData
    case networkError
    case unexpectedError(error: Error)
}

extension CharacterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingData:
            return NSLocalizedString("Discarding a character missing a valid code, magnitude, place, or time.", comment: "")
        case .networkError:
            return NSLocalizedString("Error fetching character data over the network.", comment: "")
        case .unexpectedError(let error):
            return NSLocalizedString("Received unexpected error. \(error.localizedDescription)", comment: "")
        }
    }
}
