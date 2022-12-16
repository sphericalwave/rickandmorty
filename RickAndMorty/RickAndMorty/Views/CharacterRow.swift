//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Aaron Anthony on 2022-12-11.
//

import SwiftUI

struct CharacterRow: View {
    
    let character: RickAndMorty.Character
    
    var body: some View {
        NavigationLink(destination: CharacterDetails(character: character)) {
            HStack {
                if let avatar = character.imgData {
                    Image(uiImage: UIImage(data: avatar)!)
                        .resizable()
                        .cornerRadius(3)
                        .frame(width: 54, height: 54)
                }
                else {
                    ProgressView()
                        .frame(width: 54, height: 54)
                }
                VStack(alignment: .leading) {
                    Text(character.name)
                    Text("\(character.episode.count) episodes")
                }
            }
        }
    }
}

struct CharacterRow_Previews: PreviewProvider {
    static var previews: some View {
        CharacterRow(character: .preview)
    }
}
