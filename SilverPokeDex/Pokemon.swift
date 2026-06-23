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
    var id: String { url.path }
}

struct PokemonDetail: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let baseExperience: Int
    let abilities: [Ability]
    let sprites: PokemonSprites

    enum CodingKeys: String, CodingKey {
        case id, name, sprites
        case baseExperience = "base_experience"
        case abilities
    }
}

struct Ability: Codable, Hashable {
    let ability: AbilityDetail
}

struct AbilityDetail: Codable , Hashable{
    let name: String
}

struct PokemonSprites: Codable, Hashable {
    let frontDefault: URL

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

