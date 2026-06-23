//
//  PokemonListView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct PokemonListView: View {
    // BUG: this view creates the view model but does not own it correctly.
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var searchText = ""

    var filteredPokemons: [PokemonDetail] {
        if searchText.isEmpty {
            return viewModel.pokemons
        }

        return viewModel.pokemons.filter {
            if let primaryAbilty = $0.abilities.first {
                return primaryAbilty.ability.name.localizedCaseInsensitiveContains(searchText)
            }
            return $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.pokemons.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Catching 'em all...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(filteredPokemons, id: \.id) { pokemon in
                        NavigationLink(value: pokemon) {
                            HStack {
                                AsyncImage(url: pokemon.sprites.frontDefault) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text(pokemon.name.capitalized)
                                        .font(.headline)

                                    Text("First ability: \(pokemon.abilities.first?.ability.name.capitalized ?? "Unknown")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .navigationDestination(for: PokemonDetail.self) { pokemon in
                        PokemonDetailView(pokemon: pokemon)
                    }
                    .refreshable {
                        await viewModel.loadPokemons()
                    }
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle("Pokémon")
            .onAppear {
                Task {
                    await viewModel.loadPokemons()
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
