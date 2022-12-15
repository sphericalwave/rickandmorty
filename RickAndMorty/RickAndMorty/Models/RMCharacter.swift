//
//  Character.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation
import UIKit

struct GetRMCharacterResponse: Codable {
    let results: [RMCharacter]
    let info: RMCharacterResponseInfo
}

//TODO: Prefix fix?
struct RMCharacter: Codable, Hashable {
    
    let id: Int
    let gender: String
    let url: URL
    let type: String
    let species: String
    let episode: [URL]
    let location: RMInfo
    let image: URL
    var imgData: Data?
    let origin: RMInfo
    //let created: Date   //TODO: "2017-11-04T20:51:31.373Z", isoString setting on jsondecoder
    let name: String
    let status: String
    
    struct RMInfo: Codable, Hashable {
        let name: String
        //let url: URL?  //TODO: sometimes returned as empty string "Invalid URL string."
    }
}

struct RMCharacterResponseInfo: Codable {
    let prev: URL?
    let pages: Int
    let count: Int
    let next: URL?
}
