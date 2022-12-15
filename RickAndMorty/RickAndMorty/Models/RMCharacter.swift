//
//  Character.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation

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

//extension Quake: Decodable {
//    private enum CodingKeys: String, CodingKey {
//        case magnitude = "mag"
//        case place
//        case time
//        case code
//        case detail
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        let rawMagnitude = try? values.decode(Double.self, forKey: .magnitude)
//        let rawPlace = try? values.decode(String.self, forKey: .place)
//        let rawTime = try? values.decode(Date.self, forKey: .time)
//        let rawCode = try? values.decode(String.self, forKey: .code)
//        let rawDetail = try? values.decode(URL.self, forKey: .detail)
//
//        guard let magnitude = rawMagnitude,
//              let place = rawPlace,
//              let time = rawTime,
//              let code = rawCode,
//              let detail = rawDetail
//        else {
//            throw QuakeError.missingData
//        }
//
//        self.magnitude = magnitude
//        self.place = place
//        self.time = time
//        self.code = code
//        self.detail = detail
//    }
//}

struct RMCharacterResponseInfo: Codable {
    let prev: URL?
    let pages: Int
    let count: Int
    let next: URL?
}
