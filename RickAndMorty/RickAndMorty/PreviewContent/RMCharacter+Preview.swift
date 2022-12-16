//
//  RMCharacter+Preview.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-15.
//

import Foundation

extension RickAndMorty.Character {
    
    static var preview: RickAndMorty.Character {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(RickAndMorty.Character.self, from: testJohnnyDepp)
    }
}
