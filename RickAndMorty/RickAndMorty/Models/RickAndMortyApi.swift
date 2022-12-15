//
//  RickAndMortyApi.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

//import Foundation
//
//struct RickAndMortyApi {
//    
//    var session = URLSession.shared
//    let baseUrl = "https://rickandmortyapi.com/api/"
//    
//    func getCharacters() async throws -> GetRMCharacterResponse {
//        
//        guard let url = URL(string: baseUrl + "character") else  {
//            fatalError()
//        }
//        
//        let (data, _) = try await session.data(from: url)
//        
//        //TODO: handle error cases 300, 400, 500
//        //print(response.description)
//        
//        //TODO: remove
////        let swData = SwData(data: data)
////        swData.prettyPrint()
//        
//        let decoder = JSONDecoder()
//        return try decoder.decode(GetRMCharacterResponse.self, from: data)
//    }
//}
