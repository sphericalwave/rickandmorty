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
        let latestCharacters = try await client.characters
        self.characters = latestCharacters
    }

    func deleteCharacters(atOffsets offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
    }

    func imgData(for character: RMCharacter) async throws -> Data {
        return try await client.characterImgData(from: character.image)
    }

    init(client: CharacterClient = CharacterClient()) {
        self.client = client
    }
}

