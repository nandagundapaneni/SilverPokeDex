//
//  PokemonListView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.pokemons, id: \.id) { pokemon in
                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                    HStack {
                        AsyncImage(url: pokemon.sprites.frontDefault) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(25)
                        
                        Text(pokemon.name.capitalized)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Pokémon")
            .onAppear {
                if viewModel.pokemons.isEmpty {
                    Task {
                        await viewModel.loadPokemons()
                    }
                }
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
