//
//  RMCharacter+Preview.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-15.
//

import Foundation

extension RMCharacter {
    
    static var preview: RMCharacter {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(RMCharacter.self, from: testJohnnyDepp)
    }
}
