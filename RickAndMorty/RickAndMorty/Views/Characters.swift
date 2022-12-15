//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

struct Characters: View {
    
    @EnvironmentObject var provider: QuakesProvider
    
    @AppStorage("lastUpdated")
    var lastUpdated = Date.distantFuture.timeIntervalSince1970
    
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    @State var isLoading = false
    @State var selection: Set<String> = []
    @State private var error: QuakeError?
    @State private var hasError = false

    @StateObject var vm: CharactersVm
    
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(provider.quakes, id: \.self) { quake in
//                    NavigationLink(destination: QuakeDetail(quake: quake)) {
//                        QuakeRow(quake: quake)
//                    }
                    
                    CharacterRow(character: quake)
                }
                .onDelete(perform: deleteQuakes)
                
//                ForEach(vm.searchResults, id: \.self) { character in
//                    CharacterRow(character: character)
//                        .onAppear {
//                            vm.fetchCharactersIfNeeded(currentItem: character)
//                        }
//                }
                
                if vm.isLoadingPage {
                  ProgressView()
                }
            }
            .navigationTitle("Characters")
            //.onAppear { vm.fetchCharacters() }
//            .alert("Error", isPresented: $vm.isShowingAlert,
//                   actions: {
//                        Button("Ok", role: .cancel) {
//                            vm.isShowingAlert = false
//                        }
//                    },
//                    message: {
//                        Text(vm.alertMsg)
//                    })
            .listStyle(.inset)
            .navigationTitle(title)
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $editMode)
            .refreshable {
                do {
                    try await provider.fetchQuakes()
                } catch {
                    self.error = QuakeError.missingData
                    hasError = true
                }
            }
        }
        .searchable(text: $vm.searchText, prompt: "Search for a Character by Name")
        .task {
            do {
                try await provider.fetchQuakes()
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
            try await provider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Characters(vm: CharactersVm())
    }
}
