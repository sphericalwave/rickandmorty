//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

struct Characters: View {
    
    @EnvironmentObject var provider: CharacterProvider
    
    @AppStorage("lastUpdated")
    var lastUpdated = Date.distantFuture.timeIntervalSince1970
    
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    @State var isLoading = false
    @State var selection: Set<String> = []
    @State private var error: CharacterError?
    @State private var hasError = false
    @State private var searchText = ""
    //@State var error: Error?

    //@StateObject var vm: CharactersVm
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { quake in
                    CharacterRow(character: quake)
                        //infinite scroll
                }
                .onDelete(perform: deleteQuakes)
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
    func deleteQuakes(at offsets: IndexSet) {
        provider.deleteQuakes(atOffsets: offsets)
    }
    func deleteQuakes(for codes: Set<String>) {
//        var offsetsToDelete: IndexSet = []
//        for (index, element) in provider.quakes.enumerated() {
//            if codes.contains(element.code) {
//                offsetsToDelete.insert(index)
//            }
//        }
//        deleteQuakes(at: offsetsToDelete)
//        selection.removeAll()
    }
    func fetchQuakes() async {
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
    var searchResults: [RMCharacter] {
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
