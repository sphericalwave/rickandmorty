//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

//Display 20 characters.
//User should be able to search for a character by name.

import SwiftUI

struct CharactersUi: View {
    
    @StateObject var vm: CharactersVm
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.characters, id: \.self) {
                    CharacterRow(character: $0)
                }
            }
            .navigationTitle("Characters")
            .onAppear { vm.fetchCharacters() }
            .alert("Error", isPresented: $vm.isShowingAlert, actions: {
                Button("Ok", role: .cancel) {
                    vm.isShowingAlert = false //<< redundant?
                }
            }, message: {
                Text(vm.alertMsg)
            })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
