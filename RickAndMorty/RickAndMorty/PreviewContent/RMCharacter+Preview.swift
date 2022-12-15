//
//  RMCharacter+Preview.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-15.
//

import Foundation

extension RMCharacter {
    
    static var preview: RMCharacter {
        guard let data = SwJson(filename: "RMCharacter+Preview").data() else {
            fatalError()
        }
        let t = try! DwDecoder().decode(RMCharacter.self, from: data)
        return t
    }
}
