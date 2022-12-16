//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @StateObject var characterProvider = CharacterProvider()
    var body: some Scene {
        WindowGroup {
            Characters()
                .environmentObject(characterProvider)
        }
    }
}
