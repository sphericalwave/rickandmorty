//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI
import os

struct Characters: View {
    
    @EnvironmentObject var provider: CharacterProvider
    
    @AppStorage("lastUpdated")
    var lastUpdated = Date.distantFuture.timeIntervalSince1970
    
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: Characters.self))
    
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    @State var isLoading = false
    @State var selection: Set<Int> = []
    @State private var error: CharacterError?
    @State private var hasError = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { character in
                    CharacterRow(character: character)
                        .task {
                            //TODO: handle error and fix infinite scroll
                            if character == provider.characters.last {
                                Self.logger.trace("fetch next page")
                                isLoading = true
                                do {
                                    try await provider.fetchCharacters()
                                }
                                catch {
                                    hasError = true
                                    self.error = CharacterError.missingData
                                }
                                isLoading = false
                            }
                        }
                }
                .onDelete(perform: deleteCharacters)  //TODO: do some testing on this
            }
            .navigationTitle("Characters")
            .listStyle(.inset)
            .navigationTitle(title)
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $editMode)
            .refreshable {
                do {
                    try await provider.fetchCharacters()
                } catch {
                    self.error = CharacterError.missingData
                    hasError = true
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search for a Character by Name")
        .task {
            do {
                try await provider.fetchCharacters()
            }
            catch {
                print(error)
            }
        }
    }
}

extension Characters {
    
    var title: String {
        if selectMode.isActive || selection.isEmpty {
            return "Characters"
        } else {
            return "\(selection.count) Selected"
        }
    }
    
    func deleteCharacters(at offsets: IndexSet) {
        provider.deleteCharacters(atOffsets: offsets)
    }
    
    func deleteCharacters(for codes: Set<Int>) {
        var offsetsToDelete: IndexSet = []
        for (index, element) in provider.characters.enumerated() {
            if codes.contains(element.id) {
                offsetsToDelete.insert(index)
            }
        }
        deleteCharacters(at: offsetsToDelete)
        selection.removeAll()
    }
    
    func fetchCharacters() async {
        Self.logger.trace("fetchCharacters()")
        isLoading = true
        do {
            try await provider.fetchCharacters()
            lastUpdated = Date().timeIntervalSince1970
        }
        catch {
            self.error = error as? CharacterError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
        Self.logger.trace("fetchCharacters() isLoading = false")
    }
    
    var searchResults: [RickAndMorty.Character] {
        if searchText.isEmpty {
            return provider.characters
        }
        else {
            return provider.characters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Characters()
    }
}
