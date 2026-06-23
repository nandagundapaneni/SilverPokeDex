//
//  PokemonListViewModel.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI
import Combine

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [PokemonDetail] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var statusMessage = ""

    private var api = PokemonAPI()
    private var cancellables = Set<AnyCancellable>()
    private var heartbeatTask: Task<Void, Never>?

    init() {
        observeRefreshNotifications()
        startStatusHeartbeat()
    }
    
    
    func loadPokemons() async {
        
        pokemons = []
        isLoading = true
        error = nil
        statusMessage = "Loading Pokémon..."

        defer {
            isLoading = false
        }

        do {
            let entries = try await api.fetchPokemonList()

            pokemons = try await withThrowingTaskGroup(of: PokemonDetail.self) { group in
                for entry in entries {
                    group.addTask { [api] in
                        try await api.fetchPokemonDetail(from: entry.url)
                    }
                }

                var results: [PokemonDetail] = []

                for try await detail in group {
                    results.append(detail)
                }

                return results.sorted { $0.id < $1.id }
            }

            statusMessage = "Loaded \(pokemons.count) Pokémon"

        } catch {
            self.error = error
            statusMessage = error.localizedDescription
        }
    }
    
    func loadPokemonWithTaskGroup(ids: [Int]) async throws -> [PokemonDetail] {
        let api = api

        return try await withThrowingTaskGroup(of: (Int, PokemonDetail).self) { group in
            for id in ids {
                group.addTask {
                    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
                        throw URLError(.badURL)
                    }

                    let detail = try await api.fetchPokemonDetail(from: url)
                    return (id, detail)
                }
            }

            var results: [(Int, PokemonDetail)] = []

            for try await result in group {
                results.append(result)
            }

            return results
                .sorted { $0.0 < $1.0 }
                .map { $0.1 }
        }
    }
    
    private func observeRefreshNotifications() {
        NotificationCenter.default
            .publisher(for: .pokemonDidRefresh)
            .sink { [weak self] notification in
                self?.statusMessage = "Notification received: \(notification.name.rawValue)"
            }
            .store(in: &cancellables)
    }

    private func startStatusHeartbeat() {
        heartbeatTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))

                self?.statusMessage =
                    "Last checked at \(Date().formatted(date: .omitted, time: .standard))"
            }
        }
    }

    deinit {
        heartbeatTask?.cancel()
    }
}

extension Notification.Name {
    static let pokemonDidRefresh = Notification.Name("pokemonDidRefresh")
}
