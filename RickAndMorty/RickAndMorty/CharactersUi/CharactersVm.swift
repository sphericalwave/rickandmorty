//
//  CharactersVm.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import Foundation

class CharactersVm: ObservableObject {
    
    //TODO: handle paging
    @Published var characters: [RMCharacter] = []
}
