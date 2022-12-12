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
                    //TODO: character row
                    CharacterRow(character: $0)
                }
            }
            .navigationTitle("Characters")
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
