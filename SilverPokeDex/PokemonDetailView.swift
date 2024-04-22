//
//  PokemonDetailView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct PokemonDetailView: View {
    var pokemon: PokemonDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: pokemon.sprites.frontDefault) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .cornerRadius(50)

                Text("Name: \(pokemon.name.capitalized)")
                    .font(.title)

                Text("ID: \(pokemon.id)")
                    .font(.subheadline)

                Text("Base Experience: \(pokemon.baseExperience)")
                    .font(.subheadline)

                VStack(alignment: .leading) {
                    Text("Abilities:")
                        .font(.headline)
                    ForEach(pokemon.abilities, id: \.ability.name) { ability in
                        Text(ability.ability.name.capitalized)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(pokemon.name.capitalized)
    }
}
