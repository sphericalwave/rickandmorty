/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A class to fetch and cache data from the remote server.
 */

import Foundation
import os

actor CharacterClient {
    private let characterCache: NSCache<NSString, CacheEntryObject> = NSCache()
    private let feedURL = URL(string: "https://rickandmortyapi.com/api/character")!
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return aDecoder
    }()
    
    private let downloader: any HTTPDataDownloader
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: CharacterClient.self))
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        logger.trace("init")
        self.downloader = downloader
    }
    
    var characters: [RickAndMorty.Character] {
        get async throws {
            logger.trace("get characters")

            let data = try await downloader.httpData(from: feedURL)
            let allCharacters = try decoder.decode(CharacterResponse.self, from: data)
            var updatedCharacters = allCharacters.results
                        
            try await withThrowingTaskGroup(of: (Int, Data).self) { group in
                for character in updatedCharacters {
                    group.addTask {
                        self.logger.trace("add task for \(character.name) id: \(character.id) photo")  //FIXME: memory leak?
                        let imgData = try await self.characterImgData(from: character.image)
                        return (character.id, imgData)
                    }
                }
                while let result = await group.nextResult() {
                    switch result {
                    case .failure(let error):
                        self.logger.trace("error")  //FIXME: memory leak?
                        throw error
                    case .success(let (index, imgData)):  //id
                        self.logger.trace("success \(index)") //FIXME: memory leak?
                        updatedCharacters[index - 1].imgData = imgData
                    }
                }
            }
            return updatedCharacters
        }
    }
    
    func characterImgData(from url: URL) async throws -> Data {
        if let cached = characterCache[url] {
            switch cached {
            case .ready(let imgData):
                self.logger.trace("ready") //FIXME: memory leak?
                return imgData
            case .inProgress(let task):
                self.logger.trace("inProgress") //FIXME: memory leak?
                return try await task.value
            }
        }
        let task = Task<Data, Error> {
            self.logger.trace("create task") //FIXME: memory leak?
            let data = try await downloader.httpData(from: url)
            return data
        }
        characterCache[url] = .inProgress(task)
        do {
            self.logger.trace("await photo") //FIXME: memory leak?
            let imgData = try await task.value
            characterCache[url] = .ready(imgData)
            return imgData
        } catch {
            characterCache[url] = nil
            self.logger.trace("await photo error \(error)") //FIXME: memory leak?
            throw error
        }
    }
}
