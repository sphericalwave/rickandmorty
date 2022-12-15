/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class to fetch data from the remote server and save it to the Core Data store.
*/

import Foundation

@MainActor
class QuakesProvider: ObservableObject {

    @Published var quakes: [RMCharacter] = []

    private let client: QuakeClient

    func fetchQuakes() async throws {
        let latestQuakes = try await client.quakes
        self.quakes = latestQuakes
    }

    func deleteQuakes(atOffsets offsets: IndexSet) {
        quakes.remove(atOffsets: offsets)
    }

    func location(for quake: RMCharacter) async throws -> Data {
        return try await client.quakeLocation(from: quake.image)
    }

    init(client: QuakeClient = QuakeClient()) {
        self.client = client
    }
}

