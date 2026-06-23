//
//  Pokemon.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable, Hashable {
    let name: String
    let url: URL

    var id: String {
        url.path
    }
}

struct PokemonDetail: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let baseExperience: Int
    let abilities: [Ability]
    let types: [PokemonType]
    let sprites: PokemonSprites

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abilities
        case types
        case sprites
        case baseExperience = "base_experience"
    }

    var weaknesses: [PokemonElementType] {

        let pokemonTypes = types.compactMap {
            PokemonElementType(rawValue: $0.type.name)
        }

        let allWeaknesses = pokemonTypes.flatMap {
            TypeEffectiveness.weaknesses[$0] ?? []
        }

        var seen = Set<PokemonElementType>()

        return allWeaknesses.filter { weakness in
            seen.insert(weakness).inserted
        }
    }
}

struct Ability: Codable, Hashable {
    let ability: AbilityDetail
}

struct PokemonType: Codable, Hashable {
    let type: TypeDetail
}

struct AbilityDetail: Codable, Hashable {
    let name: String
}

struct TypeDetail: Codable, Hashable {
    let name: String
}

struct PokemonSprites: Codable, Hashable {
    let frontDefault: URL

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
