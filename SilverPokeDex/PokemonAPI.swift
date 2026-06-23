//
//  PokemonAPI.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import Foundation

struct PokemonAPI: Sendable {
    
    func fetchPokemonList() async throws -> [PokemonEntry] {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=1025"
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

    func fetchPokemonDetailLegacy(
        id: Int,
        completion: @escaping (Result<PokemonDetail, Error>) -> Void
    ) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
                completion(.success(detail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchLegacyDashboard(completion: @escaping (Result<[PokemonDetail], Error>) -> Void) {
        let lock = NSLock()
        let group = DispatchGroup()
        var result: [PokemonDetail] = []
        var capturedError: Error?

        for id in 1...6 {
            group.enter()
            fetchPokemonDetailLegacy(id: id) { response in
                
                defer {
                    group.leave()
                }
                
                lock.lock()
                defer {
                    lock.unlock()
                }
                
                switch response {
                case .success(let pokemon):
                    result.append(pokemon)
                case .failure(let error):
                    capturedError = error
                }
            }
        }

        group.notify(queue: .main) {
            if let capturedError {
                completion(.failure(capturedError))
                return
            }

            result.sort { $0.id < $1.id }
            completion(.success(result))
        }
    }
}
