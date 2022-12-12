//
//  RickAndMortyApi.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation

struct RickAndMortyApi {
    
    var session = URLSession.shared
    let baseUrl = "https://rickandmortyapi.com/api/"
    
    func getCharacters() async throws -> GetRMCharacterResponse {
        
        guard let url = URL(string: baseUrl + "character") else  {
            fatalError()
        }
        
        let (data, _) = try await session.data(from: url)
        
        //TODO: handle error cases
        //print(response.description)
        
        //TODO: remove
        let swData = SwData(data: data)
        swData.prettyPrint()
        
        let decoder = JSONDecoder()
        return try decoder.decode(GetRMCharacterResponse.self, from: data)
    }
}

//might want to generate headers
//var headers = [
//    "Accept": "*/*",
//    "Accept-Encoding": "gzip, deflate",
//    "Content-Type": "application/json",
//    "Accept-Language": "en-ca",
//]
//
//let queryItems = query.map({ URLQueryItem(name: $0.key, value: $0.value) })

//var request = URLRequest(url: url)
//request.httpMethod = method
