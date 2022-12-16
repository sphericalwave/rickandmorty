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
    @State var selection: Set<String> = []
    @State private var error: CharacterError?
    @State private var hasError = false
    @State private var searchText = ""
    //@State var error: Error?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { character in
                    CharacterRow(character: character)
                        .task {
                            await fetchCharactersIfNeeded(currentItem: character)
                        }
                }
                .onDelete(perform: deleteCharacters)
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
               //error =
            }
        }
//        .alert("Error", isPresented: $hasError,
//               actions: {
//                    Button("Ok", role: .cancel) {
//                        //vm.isShowingAlert = false
//                        hasError = false
//                    }
//                },
//                message: {
//                    Text(vm.alertMsg)
//                })
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
    
    func deleteCharacters(for codes: Set<String>) {
//        var offsetsToDelete: IndexSet = []
//        for (index, element) in provider.characters.enumerated() {
//            if codes.contains(element.code) {
//                offsetsToDelete.insert(index)
//            }
//        }
//        deleteCharacters(at: offsetsToDelete)
//        selection.removeAll()
    }
    
    func fetchCharacters() async {
        Self.logger.trace("fetchCharacters()")
        isLoading = true
        do {
            try await provider.fetchCharacters()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? CharacterError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
    
    //    //TODO: .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
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
    
//    private func fetchCharacters() {
//
//        print("isLoadingPage \(isLoadingPage) canLoadMorePages \(canLoadMorePages) currentPg \(currentPage)")
//        guard !isLoadingPage && canLoadMorePages else {
//            return
//        }
//
//        isLoadingPage = true
//
//        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(currentPage)")!
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: GetRMCharacterResponse.self, decoder: JSONDecoder())  //TODO: catch decode error in combine
//            .receive(on: DispatchQueue.main)
//            .handleEvents(receiveOutput: { response in
//
//                print("response.info.next != nil \(response.info.next != nil)")
//                print(response.results.first?.name ?? "name?")
//
//                self.canLoadMorePages = response.info.next != nil  //TODO: check assumption
//                self.isLoadingPage = false
//                self.currentPage += 1
//            })
//            .map { response in
//
//                return self.characters + response.results
//            }
//            .catch { _ in
//                Just(self.characters)
//            }
//            .assign(to: &$characters)
//    }

    func fetchCharactersIfNeeded(currentItem: RickAndMorty.Character?) async {
        Self.logger.trace("fetchCharactersIfNeeded(currentItem:)")
        if isLoading {
            Self.logger.trace("fetchCharactersIfNeeded(currentItem:) - loading")
            return
        }
        guard let currentItem = currentItem else {
            Self.logger.trace("fetchCharactersIfNeeded(currentItem:) - currentItem == nil")
            await fetchCharacters()
            return
        }

        let thresholdIndex = provider.characters.index(provider.characters.endIndex, offsetBy: -3)
        if provider.characters.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            Self.logger.trace("fetchCharactersIfNeeded(currentItem:) - threshold")
            await fetchCharacters()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Characters()
    }
}
