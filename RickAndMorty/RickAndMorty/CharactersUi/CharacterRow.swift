//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

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
