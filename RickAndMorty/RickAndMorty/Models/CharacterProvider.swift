/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class to fetch data from the remote server and save it to the Core Data store.
*/

import Foundation

@MainActor
class CharacterProvider: ObservableObject {

    @Published var characters: [RMCharacter] = []

    private let client: CharacterClient

    func fetchCharacters() async throws {
        let latestQuakes = try await client.quakes
        self.characters = latestQuakes
    }

    func deleteQuakes(atOffsets offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }

    func location(for quake: RMCharacter) async throws -> Data {
        return try await client.quakeLocation(from: quake.image)
    }

    init(client: CharacterClient = CharacterClient()) {
        self.client = client
    }
}

