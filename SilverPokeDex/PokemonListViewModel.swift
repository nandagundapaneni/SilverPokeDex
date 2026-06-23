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
    @Published var loadedCount = 0
    @Published var totalCount = 0

    private var api = PokemonAPI()
    private var cancellables = Set<AnyCancellable>()
    private var heartbeatTask: Task<Void, Never>?

    init() {
        observeRefreshNotifications()
        startStatusHeartbeat()
    }
    
    
    func loadPokemons() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        loadedCount = 0
        totalCount = 0
        statusMessage = "Loading Pokémon..."

        defer {
            isLoading = false
        }

        do {
            let entries = try await api.fetchPokemonList()
            totalCount = entries.count

            let batchSize = 20
            var allResults: [PokemonDetail] = []

            for batch in entries.chunked(into: batchSize) {
                let batchResults = try await withThrowingTaskGroup(of: PokemonDetail.self) { group in
                    for entry in batch {
                        group.addTask { [api] in
                            try await api.fetchPokemonDetail(from: entry.url)
                        }
                    }

                    var results: [PokemonDetail] = []

                    for try await detail in group {
                        results.append(detail)
                    }

                    return results
                }

                allResults.append(contentsOf: batchResults)
                loadedCount = allResults.count
                statusMessage = "Loaded \(loadedCount)/\(totalCount) Pokémon"
            }

            pokemons = allResults.sorted { $0.id < $1.id }
            statusMessage = "Loaded \(pokemons.count)/\(totalCount) Pokémon"

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

                await MainActor.run {
                    guard let self else { return }

                    if !self.isLoading {
                        self.statusMessage =
                            "Last checked at \(Date().formatted(date: .omitted, time: .standard))"
                    }
                }
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
