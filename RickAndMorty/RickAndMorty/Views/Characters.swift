//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

struct Characters: View {
    
    @StateObject var vm: CharactersVm
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.searchResults, id: \.self) { character in
                    CharacterRow(character: character)
                        .onAppear {
                            vm.fetchCharactersIfNeeded(currentItem: character)
                        }
                }
                
                if vm.isLoadingPage {
                  ProgressView()
                }
            }
            .navigationTitle("Characters")
            //.onAppear { vm.fetchCharacters() }
            .alert("Error", isPresented: $vm.isShowingAlert,
                   actions: {
                        Button("Ok", role: .cancel) {
                            vm.isShowingAlert = false
                        }
                    },
                    message: {
                        Text(vm.alertMsg)
                    })
        }
        .searchable(text: $vm.searchText, prompt: "Search for a Character by Name")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Characters(vm: CharactersVm())
    }
}
