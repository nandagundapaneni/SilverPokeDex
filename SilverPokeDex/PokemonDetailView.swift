//
//  PokemonDetailView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct PokemonDetailView: View {

    let pokemon: PokemonDetail
    let namespace: Namespace.ID
    let onClose: () -> Void

    private var primaryElement: PokemonElementType? {
        pokemon.types.first.flatMap {
            PokemonElementType(rawValue: $0.type.name)
        }
    }

    private var primaryType: String {
        pokemon.types.first?.type.name.capitalized ?? "Unknown"
    }

    private var firstAbility: String {
        pokemon.abilities.first?.ability.name.capitalized ?? "Unknown"
    }

    var body: some View {
        ZStack {
            cardGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {

                    heroSection

                    detailPanel

                    closeButton
                        .padding(.top, 8)
                        .padding(.bottom, 34)
                }
                .padding(.horizontal, 22)
                .padding(.top, 72)
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Sections

private extension PokemonDetailView {

    var closeButton: some View {
        Button {
            onClose()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.black.opacity(0.85))
                .frame(width: 60, height: 60)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(
                            .white.opacity(0.45),
                            lineWidth: 1
                        )
                }
                .shadow(
                    color: .black.opacity(0.15),
                    radius: 12,
                    y: 6
                )
        }
    }
    
    var heroSection: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pokemon.name.capitalized)
                        .font(.system(size: 38, weight: .black, design: .rounded))

                    Text("NO. \(pokemon.id)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black.opacity(0.6))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text("HP")
                        .font(.caption)
                        .fontWeight(.black)

                    Text("\(pokemon.baseExperience)")
                        .font(.system(size: 42, weight: .black, design: .rounded))
                }
            }
            .foregroundStyle(.black)

            artworkPanel

            typeChips
        }
    }

    var artworkPanel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.16))

            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 220, height: 220)
                .blur(radius: 10)

            Circle()
                .stroke(.white.opacity(0.32), lineWidth: 3)
                .frame(width: 180, height: 180)

            AsyncImage(url: pokemon.sprites.frontDefault) { image in
                image
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.black)
            }
            .frame(width: 180, height: 180)
        }
        .frame(height: 220)
    }

    var typeChips: some View {
        HStack(spacing: 10) {
            ForEach(pokemon.types, id: \.type.name) { type in
                if let element = PokemonElementType(rawValue: type.type.name) {
                    Text(element.displayName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.45))
                        .clipShape(Capsule())
                }
            }

            Spacer()
        }
    }

    var detailPanel: some View {
        VStack(spacing: 12) {
            statsGrid
            attackSection
            abilitiesSection
            weaknessesSection
        }
        .padding(.horizontal, 18)
        .padding(.top, 22)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(.white.opacity(0.88))
        )
    }

    var statsGrid: some View {
        HStack(spacing: 10) {
            statCard(title: "Type", value: primaryType)
            statCard(title: "EXP", value: "\(pokemon.baseExperience)")
            statCard(title: "ID", value: "#\(pokemon.id)")
        }
    }

    func statCard(title: String, value: String) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.caption2)
                .fontWeight(.black)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
                .fontWeight(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    var attackSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(primaryElement?.emoji ?? "✨")
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(typeColor.opacity(0.18))
                    .clipShape(Circle())

                Text(firstAbility)
                    .font(.system(size: 24, weight: .black, design: .rounded))

                Spacer()

                Text("\(pokemon.baseExperience / 2)")
                    .font(.system(size: 26, weight: .black, design: .rounded))
            }

            Text("Uses \(firstAbility.lowercased()) with natural \(primaryType.lowercased()) energy.")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.75))
        }
        .padding(14)
        .background(typeColor.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    var abilitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Abilities")
                .font(.headline)
                .fontWeight(.black)

            ForEach(pokemon.abilities, id: \.ability.name) { ability in
                HStack {
                    Image(systemName: "sparkle")
                    Text(ability.ability.name.capitalized)
                    Spacer()
                }
                .font(.subheadline)
            }
        }
        .padding(14)
        .background(.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    var weaknessesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weaknesses")
                .font(.headline)
                .fontWeight(.black)

            HStack(spacing: 8) {
                ForEach(pokemon.weaknesses.prefix(4), id: \.self) { weakness in
                    Text("\(weakness.emoji) ×2")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.06))
                        .clipShape(Capsule())
                }

                Spacer()
            }
        }
        .padding(8)
        .background(.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

// MARK: - Styling

private extension PokemonDetailView {

    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [
                typeColor.opacity(0.98),
                typeColor.opacity(0.78),
                .yellow.opacity(0.75)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var typeColor: Color {
        switch primaryElement {
        case .normal: return .gray
        case .fire: return .orange
        case .water: return .blue
        case .electric: return .yellow
        case .grass: return .green
        case .ice: return .cyan
        case .fighting: return .red
        case .poison: return .purple
        case .ground: return .brown
        case .flying: return .indigo
        case .psychic: return .pink
        case .bug: return .mint
        case .rock: return .brown
        case .ghost: return .purple
        case .dragon: return .indigo
        case .dark: return .black
        case .steel: return .gray
        case .fairy: return .pink
        case .none: return .green
        }
    }
}
