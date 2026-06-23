//
//  PokemonElementType.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/06/26.
//


//
// TypeEffectiveness.swift
//

import Foundation

enum PokemonElementType: String, CaseIterable, Hashable {

    case normal
    case fire
    case water
    case electric
    case grass
    case ice
    case fighting
    case poison
    case ground
    case flying
    case psychic
    case bug
    case rock
    case ghost
    case dragon
    case dark
    case steel
    case fairy
    
    var emoji: String {
        switch self {
        case .normal: return "⚪️"
        case .fire: return "🔥"
        case .water: return "💧"
        case .electric: return "⚡️"
        case .grass: return "🌿"
        case .ice: return "❄️"
        case .fighting: return "🥊"
        case .poison: return "☠️"
        case .ground: return "🌍"
        case .flying: return "🪽"
        case .psychic: return "🔮"
        case .bug: return "🐞"
        case .rock: return "🪨"
        case .ghost: return "👻"
        case .dragon: return "🐉"
        case .dark: return "🌑"
        case .steel: return "⚙️"
        case .fairy: return "✨"
        }
    }

    var displayName: String {
        "\(emoji) \(rawValue.capitalized)"
    }
}

struct TypeEffectiveness {

    static let weaknesses: [PokemonElementType: [PokemonElementType]] = [

        .normal: [.fighting],

        .fire: [.water, .ground, .rock],

        .water: [.electric, .grass],

        .electric: [.ground],

        .grass: [.fire, .ice, .poison, .flying, .bug],

        .ice: [.fire, .fighting, .rock, .steel],

        .fighting: [.flying, .psychic, .fairy],

        .poison: [.ground, .psychic],

        .ground: [.water, .grass, .ice],

        .flying: [.electric, .ice, .rock],

        .psychic: [.bug, .ghost, .dark],

        .bug: [.fire, .flying, .rock],

        .rock: [.water, .grass, .fighting, .ground, .steel],

        .ghost: [.ghost, .dark],

        .dragon: [.ice, .dragon, .fairy],

        .dark: [.fighting, .bug, .fairy],

        .steel: [.fire, .fighting, .ground],

        .fairy: [.poison, .steel]
    ]
}
