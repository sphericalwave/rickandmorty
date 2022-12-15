//
//  CharacterDetails.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

struct CharacterDetails: View {
    
    let character: RMCharacter

    var body: some View {
        List {
            AvatarUi(url: character.image)
                .cornerRadius(9)
                .padding(.vertical)

            row(title: "Status", content: character.status)
            row(title: "Species", content: character.species)
            row(title: "Gender", content: character.gender)
            row(title: "Location", content: character.location.name)
        }
        .navigationTitle(character.name)
    }
    
    func row(title: String, content: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(content)
                .font(.subheadline)
        }
    }
}

struct CharacterUi_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetails(character: .preview)
    }
}
