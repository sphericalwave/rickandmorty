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
    @Published var isShowingAlert = false
    @Published var alertMsg = ""
    
    func fetchCharacters() {
        let api = RickAndMortyApi()
        Task {
            do {
                let response = try await api.getCharacters()
                DispatchQueue.main.async { [weak self] in
                    self?.characters = response.results
                }
            }
            catch {
                DispatchQueue.main.async { [weak self] in
                    print(error)
                    self?.alertMsg = error.localizedDescription.debugDescription
                    self?.isShowingAlert = true
                }
            }
        }
    }
}


