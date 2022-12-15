//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Aaron Anthony on 2022-12-12.
//

import XCTest
@testable import RickAndMorty

final class RickAndMortyTests: XCTestCase {

    func testCharacterApi() async throws  {

        var session = URLSession.shared
        let baseUrl = "https://rickandmortyapi.com/api/"
        
        guard let url = URL(string: baseUrl + "character") else  {
            fatalError()
        }
        
        let (data, _) = try await session.data(from: url)
        
        //TODO: handle error cases 300, 400, 500
        //print(response.description)
        
        //TODO: remove
        let swData = SwData(data: data)
        swData.prettyPrint()
        
        let decoder = JSONDecoder()
        let response = try! decoder.decode(GetRMCharacterResponse.self, from: data)
        
        XCTAssertEqual(response.results.count, 20)
    }
    
    func testCharacterPages() async throws  {

        var session = URLSession.shared
        let baseUrl = "https://rickandmortyapi.com/api/"
        
        guard let url = URL(string: baseUrl + "character" + "/?page=2") else  {
            fatalError()
        }
        
        let (data, _) = try await session.data(from: url)
        
        //TODO: handle error cases 300, 400, 500
        //print(response.description)
        
        //TODO: remove
        let swData = SwData(data: data)
        swData.prettyPrint()
        
        let decoder = JSONDecoder()
        let response = try! decoder.decode(GetRMCharacterResponse.self, from: data)
        
        XCTAssertEqual(response.results.count, 20)
    }
    
    func testPreviewCharacter() {
        let c = RMCharacter.preview
        XCTAssertEqual(c.name, "Johnny Depp")
    }
}
