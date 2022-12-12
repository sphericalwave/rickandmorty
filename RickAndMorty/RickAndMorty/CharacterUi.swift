//
//  CharacterUi.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

//○ Photo/Image
//○ Name
//○ Status
//○ Species
//○ Gender
//○ Current location

import SwiftUI

struct CharacterUi: View {
    
    let character: RMCharacter

    var body: some View {
        VStack {
            Image(systemName: "person")
                .imageScale(.large)
            Text(character.name)
            Text(character.status)
            Text(character.species)
            Text(character.gender)
            Text(character.currentLocation)
        }
        .padding()
    }
}

//struct CharacterUi_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterUi()
//    }
//}
