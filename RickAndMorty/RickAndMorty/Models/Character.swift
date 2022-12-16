//
//  Character.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation
import UIKit

struct CharacterResponse: Codable {
    let results: [Character]
    let info: CharacterResponseInfo
}

struct Character: Codable, Hashable {
    
    let id: Int
    let gender: String
    let url: URL
    let type: String
    let species: String
    let episode: [URL]
    let location: Info
    let image: URL
    var imgData: Data?
    let origin: Info
    let created: Date   //"2017-11-04T20:51:31.373Z"
    let name: String
    let status: String
    
    struct Info: Codable, Hashable {
        let name: String
        //let url: URL?  //TODO: sometimes returned as empty string "Invalid URL string."
    }
}

struct CharacterResponseInfo: Codable {
    let prev: URL?
    let pages: Int
    let count: Int
    let next: URL?
}
