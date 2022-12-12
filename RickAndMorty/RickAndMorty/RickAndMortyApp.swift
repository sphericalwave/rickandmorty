//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    
    var body: some Scene {
        WindowGroup {
            CharactersUi(vm: CharactersVm())
        }
    }
}
