//
//  Sequence+KeyPathSorted.swift
//  
//
//  Created by Andreas Osberghaus on 16.02.21.
//

import Foundation

extension Sequence {
    func sorted<Value>(
        by keyPath: KeyPath<Self.Element, Value>,
        using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Self.Element] {
        return try self.sorted(by: {
            try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        })
    }

    func sorted<Value: Comparable>(
        by keyPath: KeyPath<Self.Element, Value>
    ) -> [Self.Element] {
        return self.sorted(by: keyPath, using: <)
    }

}
