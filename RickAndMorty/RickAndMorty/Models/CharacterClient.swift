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
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()
    
    private let downloader: any HTTPDataDownloader
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: CharacterClient.self))
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        logger.trace("init")
        self.downloader = downloader
    }
    
    var quakes: [RMCharacter] {
        get async throws {
            logger.trace("get quakes")

            let data = try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GetRMCharacterResponse.self, from: data)
            var updatedQuakes = allQuakes.results
                        
            try await withThrowingTaskGroup(of: (Int, Data).self) { group in
                for quake in updatedQuakes {
                    group.addTask {
                        self.logger.trace("add task for \(quake.name) id: \(quake.id) photo")  //FIXME: memory leak?
                        let location = try await self.quakeLocation(from: quake.image)
                        return (quake.id, location)
                    }
                }
                while let result = await group.nextResult() {
                    switch result {
                    case .failure(let error):
                        self.logger.trace("error")  //FIXME: memory leak?
                        throw error
                    case .success(let (index, location)):  //id
                        self.logger.trace("success \(index)") //FIXME: memory leak?
                        updatedQuakes[index - 1].imgData = location
                    }
                }
            }
            return updatedQuakes
        }
    }
    
    func quakeLocation(from url: URL) async throws -> Data {
        if let cached = characterCache[url] {
            switch cached {
            case .ready(let location):
                self.logger.trace("ready") //FIXME: memory leak?
                return location
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
            let location = try await task.value
            characterCache[url] = .ready(location)
            return location
        } catch {
            characterCache[url] = nil
            self.logger.trace("await photo error \(error)") //FIXME: memory leak?
            throw error
        }
    }
}
