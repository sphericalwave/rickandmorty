//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

//  For each character show a thumbnail, name and the amount of episodes the character appeared in.

import SwiftUI

struct CharacterRow: View {
    
    let character: RMCharacter
    
    var body: some View {
        NavigationLink(destination: CharacterUi(character: character)) {
            HStack {
                Image(systemName: "person")
                    .imageScale(.medium)
                
                VStack {
                    Text(character.name)
                    Text("# episodes")
                }
            }
        }
    }
}
