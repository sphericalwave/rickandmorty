/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A class to fetch and cache data from the remote server.
 */

import Foundation
import os
import UIKit

actor CharacterClient {
    private var characters: [RickAndMorty.Character] = []  //this is a cache of sorts too which is meh
    private let characterCache: NSCache<NSString, CacheEntryObject> = NSCache()
    private let feedURL = URL(string: "https://rickandmortyapi.com/api/character")!
    private var nextTwentyCharacters: URL?
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return aDecoder
    }()
    
    private let downloader: any HTTPDataDownloader
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: CharacterClient.self))
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        Self.logger.trace("init")
        self.downloader = downloader
    }
    
    func nextTwentyCharacters() async throws -> [RickAndMorty.Character] {
        Self.logger.trace("nextTwentyCharacters")
        
        var updatedCharacters = characters
        
        if nextTwentyCharacters != nil {
            let data = try await downloader.httpData(from: nextTwentyCharacters!)
            let allCharacters = try decoder.decode(CharacterResponse.self, from: data)
            updatedCharacters.append(contentsOf: allCharacters.results)  //TODO: this is an issue, maybe put characters in cache
            nextTwentyCharacters = allCharacters.info.next
        }
        else { //FIXME: this will get called when you reach the end of all the characters
            let data = try await downloader.httpData(from: feedURL)
            let allCharacters = try decoder.decode(CharacterResponse.self, from: data)
            updatedCharacters.append(contentsOf: allCharacters.results)
            nextTwentyCharacters = allCharacters.info.next
        }
        
        try await withThrowingTaskGroup(of: (Int, Data).self) { group in
            for character in updatedCharacters {
                group.addTask {
                    Self.logger.trace("add task for \(character.name) id: \(character.id) photo")
                    let imgData = try await self.characterImgData(from: character.image)
                    return (character.id, imgData)
                }
            }
            while let result = await group.nextResult() {
                switch result {
                case .failure(let error):
                    Self.logger.trace("error")
                    throw error
                case .success(let (id, imgData)):
                    Self.logger.trace("success \(id)")
                    updatedCharacters[id - 1].imgData = imgData  //Thread 12: Fatal error: Index out of range
                }
            }
        }
        characters = updatedCharacters
        return updatedCharacters
    }
    
    
    func characterImgData(from url: URL) async throws -> Data {
        if let cached = characterCache[url] {
            switch cached {
            case .ready(let imgData):
                Self.logger.trace("ready")
                return imgData
            case .inProgress(let task):
                Self.logger.trace("inProgress")
                return try await task.value
            }
        }
        let task = Task<Data, Error> {
            Self.logger.trace("create task")
            let data = try await downloader.httpData(from: url)
            return data
        }
        characterCache[url] = .inProgress(task)
        do {
            Self.logger.trace("await photo")
            let imgData = try await task.value
            characterCache[url] = .ready(imgData)
            return imgData
        } catch {
            characterCache[url] = nil
            Self.logger.trace("await photo error \(error)")
            throw error
        }
    }
    
    func deleteCharacters(atOffsets offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }
}
