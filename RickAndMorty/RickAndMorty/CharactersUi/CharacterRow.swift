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
                AvatarUi(url: character.image)
                    .cornerRadius(3)
                    .frame(width: 54, height: 54)
                
                VStack(alignment: .leading) {
                    Text(character.name)
                    Text("\(character.episode.count) episodes")
                }
            }
        }
    }
}
