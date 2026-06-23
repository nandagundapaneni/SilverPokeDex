//
//  PokemonListView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct PokemonListView: View {

    @StateObject private var viewModel = PokemonListViewModel()
    @State private var searchText = ""
    @State private var selectedPokemon: PokemonDetail?
    @Namespace private var pokemonTransition

    var filteredPokemons: [PokemonDetail] {
        guard !searchText.isEmpty else {
            return viewModel.pokemons
        }

        return viewModel.pokemons.filter { pokemon in
            let matchesName =
                pokemon.name.localizedCaseInsensitiveContains(searchText)

            let matchesAbility =
                pokemon.abilities.contains {
                    $0.ability.name.localizedCaseInsensitiveContains(searchText)
                }

            let matchesType =
                pokemon.types.contains {
                    $0.type.name.localizedCaseInsensitiveContains(searchText)
                }

            let matchesID =
                String(pokemon.id).contains(searchText)

            return matchesName || matchesAbility || matchesType || matchesID
        }
    }

    var body: some View {
        ZStack {
            NavigationStack {
                contentView
                    .navigationTitle("Pokémon")
                    .searchable(text: $searchText)
                    .task {
                        await viewModel.loadPokemons()
                    }
                    .toolbar {
                        #if os(macOS)
                        Button {
                            Task {
                                await viewModel.loadPokemons()
                            }
                        } label: {
                            Label("Reload", systemImage: "arrow.clockwise")
                        }
                        #endif
                    }
            }
            .opacity(selectedPokemon == nil ? 1 : 0)

            if let selectedPokemon {
                PokemonDetailView(
                    pokemon: selectedPokemon,
                    namespace: pokemonTransition
                ) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
                        self.selectedPokemon = nil
                    }
                }
                .zIndex(1)
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Content

private extension PokemonListView {

    @ViewBuilder
    var contentView: some View {
        if viewModel.pokemons.isEmpty && viewModel.isLoading {
            loadingView

        } else if viewModel.pokemons.isEmpty {
            emptyView

        } else {
            pokemonScrollView
        }
    }

    var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView(
                value: Double(viewModel.loadedCount),
                total: Double(max(viewModel.totalCount, 1))
            )
            .progressViewStyle(.linear)
            .frame(maxWidth: 360)
            .padding(.horizontal, 40)

            Text(viewModel.statusMessage.isEmpty
                 ? "Catching Pokémon..."
                 : viewModel.statusMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var emptyView: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.secondary)

            Text("No Pokémon Loaded")
                .font(.headline)

            Button("Reload") {
                Task {
                    await viewModel.loadPokemons()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var pokemonScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredPokemons, id: \.id) { pokemon in
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
                            selectedPokemon = pokemon
                        }
                    } label: {
                        pokemonRow(pokemon)
                            .matchedGeometryEffect(
                                id: "pokemon-card-\(pokemon.id)",
                                in: pokemonTransition
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        #if os(iOS)
        .refreshable {
            await viewModel.loadPokemons()
        }
        #endif
    }
}

// MARK: - Row

private extension PokemonListView {

    func pokemonRow(_ pokemon: PokemonDetail) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(rowTypeColor(for: pokemon).opacity(0.22))
                    .frame(width: 64, height: 64)

                AsyncImage(url: pokemon.sprites.frontDefault) { image in
                    image
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(pokemon.name.capitalized)
                        .font(.headline)
                        .fontWeight(.black)

                    Spacer()

                    Text("#\(pokemon.id)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }

                Text("Ability: \(pokemon.abilities.first?.ability.name.capitalized ?? "Unknown")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    ForEach(pokemon.types, id: \.type.name) { type in
                        if let element = PokemonElementType(rawValue: type.type.name) {
                            Text(element.displayName)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(rowTypeColor(for: pokemon).opacity(0.16))
                                .clipShape(Capsule())
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [
                    rowTypeColor(for: pokemon).opacity(0.18),
                    Color.yellow.opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.6), lineWidth: 1)
        }
    }

    func rowTypeColor(for pokemon: PokemonDetail) -> Color {
        guard let element = pokemon.types.first.flatMap({
            PokemonElementType(rawValue: $0.type.name)
        }) else {
            return .green
        }

        switch element {
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
        }
    }
}
