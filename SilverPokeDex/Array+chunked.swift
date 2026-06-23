//
//  Array+chunked.swift
//  SilverPokeDex
//
//  Created by Nanda Gundapaneni on 23/06/26.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else {
            return [self]
        }

        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
