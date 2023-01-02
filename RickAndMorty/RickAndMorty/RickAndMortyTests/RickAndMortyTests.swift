//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Aaron Anthony on 2022-12-12.
//

import XCTest
@testable import RickAndMorty

final class RickAndMortyTests: XCTestCase {
    
    func testCharacterDecoderDecodesCharacter() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        let character = try decoder.decode(RickAndMorty.Character.self, from: testJohnnyDepp)
        
        XCTAssertEqual(character.name, "Johnny Depp")
    }
    
    func testClientDoesFetchCharacterData() async throws {
        let downloader = TestDownloader()
        let client = CharacterClient(downloader: downloader)
        let characters = try await client.fetchCharacters()

        XCTAssertEqual(characters.count, 20)
    }

    func testCharacterApi() async throws  {

        let session = URLSession.shared
        let baseUrl = "https://rickandmortyapi.com/api/"
        
        guard let url = URL(string: baseUrl + "character") else  {
            fatalError()
        }
        
        let (data, _) = try await session.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        do {
            let response = try decoder.decode(CharacterResponse.self, from: data)
            XCTAssertEqual(response.results.count, 20)
        }
        catch {
            print(error)
            throw error
        }
    }
    
    func testCharacterPages() async throws  {

        let session = URLSession.shared
        let baseUrl = "https://rickandmortyapi.com/api/"
        
        guard let url = URL(string: baseUrl + "character" + "/?page=2") else  {
            fatalError()
        }
        
        let (data, _) = try await session.data(from: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        do {
            let response = try decoder.decode(CharacterResponse.self, from: data)
            XCTAssertEqual(response.results.count, 20)
        }
        catch {
            print(error)
            throw error
        }
    }
}
