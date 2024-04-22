//
//  PokemonAPI.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import Foundation

struct PokemonAPI {
    func fetchPokemonList() async throws -> [PokemonEntry] {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        return decodedResponse.results
    }

    func fetchPokemonDetail(from url: URL) async throws -> PokemonDetail {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
        return decodedDetail
    }
}


