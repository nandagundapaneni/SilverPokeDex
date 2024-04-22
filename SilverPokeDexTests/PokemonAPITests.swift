//
//  PokemonAPITests.swift
//  SilverPokeDexTests
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import XCTest

final class PokemonAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPokemonList() async throws {
        let api = PokemonAPI()
        do {
            let pokemons = try await api.fetchPokemonList()
            XCTAssertFalse(pokemons.isEmpty, "No Pokémon were fetched")
        } catch {
            XCTFail("Fetching Pokémon failed with error: \(error)")
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
