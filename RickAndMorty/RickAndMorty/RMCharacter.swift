//
//  Character.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation

struct RMCharacter: Codable, Hashable {
    let photo: URL
    let name: String
    let status: String
    let species: String
    let gender: String
    let currentLocation: String
}
