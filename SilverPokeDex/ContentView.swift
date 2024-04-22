//
//  ContentView.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/04/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            PokemonListView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
