//
//  PokemonListViewModel.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI
import Combine

@MainActor
class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [PokemonDetail] = []
    @Published var isLoading = false
    @Published var error: Error?

    private var api = PokemonAPI()

    func loadPokemons() async {
        isLoading = true
        error = nil
        do {
            let entries = try await api.fetchPokemonList()
            for entry in entries {
                do {
                    let detail = try await api.fetchPokemonDetail(from: entry.url)
                    pokemons.append(detail)
                } catch {
                    print("Failed to load details for \(entry.name)")
                }
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
